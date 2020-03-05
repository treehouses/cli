function services {
  local service_name command command_option service results installed
  local array running port_string found local_url tor_url
  service_name="$1"
  command="$2"
  command_option="$3"

  # list all services available to be installed
  if [ "$service_name" = "available" ]; then
    if [ -d "$TEMPLATES/services/install-scripts" ]; then
      for file in $TEMPLATES/services/install-scripts/*
      do
        echo "${file##*/}" | sed -e 's/^install-//' -e 's/.sh$//'
      done
    else
      echo "$TEMPLATES/services/install-scripts directory does not exist"
      exit 1
    fi    
  # list all installed services
  elif [ "$service_name" = "installed" ]; then
    if [ "$command" = "full" ]; then
      docker ps -a
    elif [ -z "$command" ]; then
      installed=$(docker images --format '{{.Repository}}' | sed 's:.*/::')
      array=($installed)
      IFS=$'\n' sorted=($(sort <<<"${array[*]}"))
      unset IFS
      available=($(services available))
      comm -12 <(printf '%s\n' "${sorted[@]}") <(printf '%s\n' "${available[@]}")
    fi
  # list all running services
  elif [ "$service_name" = "running" ]; then
    if [ "$command" = "full" ]; then
      docker ps
    elif [ -z "$command" ]; then
      running=$(docker ps --format '{{.Names}}')
      array=($running)
      results=""
      for i in "${array[@]}"
      do
        results+="${i%%_*}"
        results+=" "
      done
      echo ${results} | tr ' ' '\n' | uniq | xargs
    fi
  # list all ports used by services
  elif [ "$service_name" = "ports" ]; then
    array=($(services available))
    for i in "${array[@]}"
    do
      port_string=""
      for j in $(seq 1 "$(get_port $i | wc -l)")
      do
        port_string+=$(get_port $i | sed -n "$j p")
        port_string+=" "
      done
      if [ ! -z "$port_string" ]; then
        printf "%-10s %20s %-5s\n" "$i" "port" "$(echo $port_string | xargs | sed -e 's/ /, /g')"
      fi
    done
  else
    if [ -z "$command" ]; then
      echo "no command given"
      exit 1
    else
      case "$command" in
        install)
          if [ "$service_name" = "planet" ]; then
            if bash $TEMPLATES/services/install-scripts/install-planet.sh ; then
              echo "planet installed"
            else
              echo "error running install script"
              exit 1
            fi
          elif bash $TEMPLATES/services/install-scripts/install-${service_name}.sh ; then
            if docker-compose -f /srv/${service_name}/${service_name}.yml pull ${service_name} ; then
              echo "${service_name} installed"
            else
              echo "error pulling docker image"
              exit 1
            fi
          else
            echo "error running install script"
            exit 1
          fi
          ;;
        up)
          case "$service_name" in
            planet)
              check_space "planet"
              if [ -f /srv/planet/pwd/credentials.yml ]; then
                if docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -f /srv/planet/pwd/credentials.yml -p planet up -d ; then
                  echo "planet built and started"
                else
                  echo "error building planet"
                  exit 1
                fi
              else
                if docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -p planet up -d ; then
                  echo "planet built and started"
                else
                  echo "error building planet"
                  exit 1
                fi
              fi
              for i in $(seq 1 "$(get_port $service_name | wc -l)")
              do
                check_tor "$(get_port $service_name | sed -n "$i p")"
              done
              ;;
            kolibri|nextcloud|moodle|privatebin|portainer|netdata|ntopng)
              check_space $service_name
              docker_compose_up $service_name
              for i in $(seq 1 "$(get_port $service_name | wc -l)")
              do
                check_tor "$(get_port $service_name | sed -n "$i p")"
              done
              ;;
            pihole)
              check_space "pihole"
              service dnsmasq stop
              docker_compose_up "pihole"
              for i in $(seq 1 "$(get_port $service_name | wc -l)")
              do
                check_tor "$(get_port $service_name | sed -n "$i p")"
              done
              ;;
            *)
              echo "unknown service"
              ;;
          esac
          ;;
        down)
          if check_available_services $service_name; then
            if [ ! -e /srv/${service_name}/${service_name}.yml ]; then
              echo "${service_name}.yml not found"
            else
              docker-compose -f /srv/${service_name}/${service_name}.yml down
              echo "${service_name} stopped and removed"
            fi
          else
            echo "unknown service"
          fi
          ;;
        start)
          if check_available_services $service_name; then
            if docker ps -a | grep -q $service_name; then
              docker-compose -f /srv/${service_name}/${service_name}.yml start
              echo "${service_name} started"
            else
              echo "${service_name} not found"
            fi
          else
            echo "unknown service"
          fi
          ;;
        stop)
          if check_available_services $service_name; then
            if docker ps -a | grep -q $service_name; then
              docker-compose -f /srv/${service_name}/${service_name}.yml stop
              echo "${service_name} stopped"
            else
              echo "${service_name} not found"
            fi
          else
            echo "unknown service"
          fi
          ;;
        restart)
          services $service_name stop
          services $service_name up
          ;;
        autorun)
          # if no command_option, output true or false
          if [ -z "$command_option" ]; then
            if [ ! -e /boot/autorun ]; then
              echo "false"
            else
              found=false
              while read -r line; do
                if [[ $line == "${service_name}_autorun=true" ]]; then
                  found=true
                  break
                fi
              done < /boot/autorun
              if [ "$found" = true ]; then
                echo "true"
              else
                echo "false"
              fi
            fi
          # make service autostart
          elif [ "$command_option" = "true" ]; then
            # if no autorun file, create one
            if [ ! -e /boot/autorun ]; then
              {
                echo "#!/bin/bash"
                echo
                echo "sleep 1"
                echo
              } > /boot/autorun
            fi
            # check if autorun lines exist
            found=false
            while read -r line; do
              if [[ $line == *"$service_name up"* ]]; then
                found=true
                break
              fi
            done < /boot/autorun
            # if lines aren't found, add them
            if [ "$found" = false ]; then
              if [ ! -e /srv/${service_name}/autorun ]; then
                echo "${service_name} autorun file not found"
                echo "run \"$BASENAME services ${service_name} install\" first"
                exit 1
              fi
              cat /srv/${service_name}/autorun >> /boot/autorun
            else
              sed -i "/${service_name}_autorun=false/c\\${service_name}_autorun=true" /boot/autorun
            fi
            echo "service autorun set to true"
          # stop service from autostarting
          elif [ "$command_option" = "false" ]; then
            if [ -e /boot/autorun ]; then
              # if autorun lines exist, set flag to false
              sed -i "/${service_name}_autorun=true/c\\${service_name}_autorun=false" /boot/autorun
            fi
            echo "service autorun set to false"
          else
            echo "unknown command option"
          fi
          ;;
        ps)
          docker ps -a | grep $service_name
          ;;
        url)
          if [ "$command_option" = "local" ]; then
            for i in $(seq 1 "$(get_port $service_name | wc -l)")
            do
              local_url=$(networkmode info | grep -oP -m1 '(?<=ip: ).*?(?=,)')
              local_url+=":"
              local_url+=$(get_port $service_name | sed -n "$i p")
              if [ "$service_name" = "pihole" ]; then
                local_url+="/admin"
              fi
              echo $local_url
            done
          elif [ "$command_option" = "tor" ]; then
            for i in $(seq 1 "$(get_port $service_name | wc -l)")
            do
              tor_url=$(tor)
              tor_url+=":"
              tor_url+=$(get_port $service_name | sed -n "$i p")
              if [ "$service_name" = "pihole" ]; then
                tor_url+="/admin"
              fi
              echo $tor_url
            done
          elif [ "$command_option" = "both" ]; then
            services $service_name url local
            services $service_name url tor
          else
            echo "unknown command"
          fi
          ;;
        port)
          get_port $service_name
          ;;
        info)
          if cat /srv/${service_name}/info ; then
            :
          else
            echo "${service_name} info not found"
            exit 1
          fi
          ;;
        *)
          echo "unknown command"
          ;;
      esac
    fi
  fi
}

function check_available_services {
  array=($(services available))
  for service in "${array[@]}"
  do
    if [ "${1}" == "$service" ]; then
      return 0
    fi
  done
  return 1
}

function docker_compose_up {
  if docker-compose -f /srv/${1}/${1}.yml -p ${1} up -d ; then
    echo "${1} built and started"
  else
    echo "error building ${1}"
    exit 1
  fi
}

function check_space {
  local service_size service_name free_space
  # service_size=$(curl -s -H "Authorization: JWT " "https://hub.docker.com/v2/repositories/${1}/tags/?page_size=100" | jq -r '.results[] | select(.name == "latest") | .images[0].size')
  service_name="$1"
  service_size=$(numfmt --from-unit=Mi < /srv/${service_name}/size)
  free_space=$(df -Ph /var/lib/docker | awk 'END {print $4}' | numfmt --from=iec)

  if (( service_size > free_space )); then
    echo "service size:" $service_size
    echo "free space:" $free_space
    echo "not enough free space"
    exit 1
  fi
}

function check_tor {
  if [ "$(tor status)" = "active" ]; then
    echo "tor active"
    if ! tor list | grep -w $1; then
      echo "adding port ${1}"
      tor add $1
    fi
  fi
}

function get_port {
  if [ -f /srv/${1}/ports ]; then
    cat /srv/${1}/ports
  fi
}

function services_help {
  echo
  echo "Available Services:"
  echo
  echo "  Planet"
  echo "  Kolibri"
  echo "  Nextcloud"
  echo "  Netdata"
  echo "  Pi-hole"
  # echo "  Moodle"
  echo "  PrivateBin"
  echo "  Portainer"
  echo "  Ntopng"
  echo
  echo
  echo "Top-Level Commands:"
  echo
  echo "  Usage:"
  echo "    $(basename "$0") services available [full]"
  echo "              ..... installed [full]"
  echo "              ..... running [full]"
  echo "              ..... ports"
  echo
  echo "    available               lists all available services"
  echo "        [full]                  full details"
  echo
  echo "    installed               lists all installed services"
  echo "        [full]                  full details"
  echo
  echo "    running                 lists all running services"
  echo "        [full]                  full details"
  echo
  echo "    ports                   lists all ports used by services"
  echo
  echo "  Examples:"
  echo
  echo "    $(basename "$0") services available"
  echo
  echo "    $(basename "$0") services running full"
  echo
  echo
  echo "Service-Specific Commands:"
  echo
  echo "  Usage:"
  echo "    $(basename "$0") services <service_name> install"
  echo "                             ..... up"
  echo "                             ..... down"
  echo "                             ..... start"
  echo "                             ..... stop"
  echo "                             ..... autorun [true|false]"
  echo "                             ..... ps"
  echo "                             ..... url <local|tor|both>"
  echo "                             ..... port"
  echo "                             ..... info"
  echo
  echo "    install                 installs and pulls <service_name>"
  echo
  echo "    up                      builds and starts <service_name>"
  echo
  echo "    down                    stops and removes <service_name>"
  echo
  echo "    start                   starts <service_name>"
  echo
  echo "    stop                    stops <service_name>"
  echo
  echo "    autorun                 outputs true if <service_name> is set to autorun or false otherwise"
  echo "        [true]                  sets <service_name> autorun to true"
  echo "        [false]                 sets <service_name> autorun to false"
  echo
  echo "    ps                      outputs the containers related to <service_name>"
  echo
  echo "    url                     <requires one of the options given below>"
  echo "        <local>                 lists the local url for <service_name>"
  echo "        <tor>                   lists the tor url for <service_name>"
  echo "        <both>                  lists both the local and tor url for <service_name>"
  echo
  echo "    port                    lists the ports used by <service_name>"
  echo
  echo "    info                    gives some information about <service_name>"
  echo
  echo "  Examples:"
  echo
  echo "    $(basename "$0") services planet up"
  echo
  echo "    $(basename "$0") services planet autorun"
  echo
  echo "    $(basename "$0") services planet autorun true"
  echo
  echo "    $(basename "$0") services planet url local"
  echo
}
