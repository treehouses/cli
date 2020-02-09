function services {
  local service_name command command_option service results installed
  local array running port_string found local_url tor_url
  service_name="$1"
  command="$2"
  command_option="$3"

  # list all services available to be installed
  if [ "$service_name" = "available" ]; then
    if [ "$command" = "full" ]; then
      while IFS= read -r -d '' service
      do
        service=$(basename "$service")
        find_available_services "$service"
      done < <(find "$TEMPLATES/services/"* -maxdepth 1 -type d -print0)
    elif [ -z "$command" ]; then
      results=""

      while IFS= read -r -d '' service
      do
        results+=$(basename "$service")
        results+=" "
      done < <(find "$TEMPLATES/services/"* -maxdepth 1 -type d -print0)

      echo ${results}
    fi
  # list all installed services
  elif [ "$service_name" = "installed" ]; then
    if [ "$command" = "full" ]; then
      docker ps -a
    elif [ -z "$command" ]; then
      installed=$(docker ps -a --format '{{.Names}}')
      array=($installed)
      results=""

      for i in "${array[@]}"
      do
        results+="${i%%_*}"
        results+=" "
      done

      echo ${results} | tr ' ' '\n' | uniq | xargs
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
      printf "%-10s %20s %-5s\n" "$i" "port" "$(echo $port_string | xargs | sed -e 's/ /, /g')"
    done
  else
    if [ -z "$command" ]; then
      echo "no command given"
      exit 1
    else
      case "$command" in
        up)
          case "$service_name" in
            planet)
              check_space "treehouses/planet"
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
              check_tor "80"
              ;;
            kolibri)
              check_space "treehouses/kolibri"
              create_yml "kolibri"
              docker_compose_up "kolibri"
              check_tor "8080"
              ;;
            nextcloud)
              check_space "library/nextcloud"
              create_yml "nextcloud"
              docker_compose_up "nextcloud"
              check_tor "8081"
              ;;
            pihole)
              check_space "pihole/pihole"
              create_yml "pihole"
              service dnsmasq stop
              docker_compose_up "pihole"
              check_tor "8053"
              ;;
            moodle)
              check_space "treehouses/moodle"
              create_yml "moodle"
              docker_compose_up "moodle"
              check_tor "8082"
              ;;
            privatebin)
              check_space "treehouses/privatebin"
              create_yml "privatebin"
              docker_compose_up "privatebin"
              check_tor "8083"
              ;;
            portainer)
              check_space "portainer/portainer"
              create_yml "portainer"
              docker_compose_up "portainer"
              check_tor "9000"
              ;;
            ntopng)            
              check_space "jonbackhaus/ntopng"
              create_yml "ntopng"
              docker_compose_up "ntopng"
              check_tor "8090"
              ;;
            *)
              echo "unknown service"
              ;;
          esac
          ;;

        down)
          case "$service_name" in
            planet|kolibri|pihole|moodle|privatebin|nextcloud|portainer|ntopng)
              if [ ! -e /srv/${service_name}/${service_name}.yml ]; then
                echo "yml file doesn't exit"
              else
                docker-compose -f /srv/${service_name}/${service_name}.yml down
                echo "${service_name} stopped and removed"
              fi
              ;;
            *)
              echo "unknown service"
              ;;
          esac
          ;;

        start)
          case "$service_name" in
            planet|kolibri|pihole|moodle|privatebin|nextcloud|portainer|ntopng)
              if docker ps -a | grep -q $service_name; then
                docker-compose -f /srv/${service_name}/${service_name}.yml start
                echo "${service_name} started"
              else
                echo "service not found"
              fi
              ;;
            *)
              echo "unknown service"
              ;;
          esac
          ;;

        stop)
          case "$service_name" in
            planet|kolibri|pihole|moodle|privatebin|nextcloud|portainer|ntopng)
              if docker ps -a | grep -q $service_name; then
                docker-compose -f /srv/${service_name}/${service_name}.yml stop
                echo "${service_name} stopped"
              else
                echo "service not found"
              fi
              ;;
            *)
              echo "unknown service"
              ;;
          esac
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
              cat $TEMPLATES/services/${service_name}/${service_name}_autorun >> /boot/autorun
            else
              sed -i "/${service_name}_autorun=false/c\\${service_name}_autorun=true" /boot/autorun
            fi

            # # if yml file doesn't exist, create it
            # if [ -e /srv/${service_name}/${service_name}.yml ]; then
            #   bash $TEMPLATES/services/${service_name}/${service_name}_yml.sh
            # fi
            
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

        info)
          case "$service_name" in
            planet)
              echo "https://github.com/open-learning-exchange/planet"
              echo
              echo "\"Planet Learning is a generic learning system built in Angular"
              echo "& CouchDB.\""
              ;;
            kolibri)
              echo "https://github.com/treehouses/kolibri"
              echo
              echo "\"Kolibri is the offline learning platform from Learning Equality.\""
              ;;
            nextcloud)
              echo "https://github.com/nextcloud"
              echo
              echo "\"A safe home for all your data. Access & share your files, calendars,"
              echo "contacts, mail & more from any device, on your terms.\""
              ;;
            pihole)
              echo "https://github.com/pi-hole/docker-pi-hole"
              echo
              echo "\"The Pi-hole® is a DNS sinkhole that protects your devices from"
              echo "unwanted content, without installing any client-side software.\""
              ;;
            moodle)
              echo "https://github.com/treehouses/moodole"
              echo
              echo "\"Moodle <https://moodle.org> is a learning platform designed to"
              echo "provide educators, administrators and learners with a single robust,"
              echo "secure and integrated system to create personalised learning"
              echo "environments.\""
              ;;
            privatebin)
              echo "https://github.com/treehouses/privatebin"
              echo
              echo "\"A minimalist, open source online pastebin where the server has"
              echo "zero knowledge of pasted data. Data is encrypted/decrypted in the"
              echo "browser using 256 bits AES. https://privatebin.info/\""
              ;;
            portainer)
              echo "https://github.com/portainer/portainer"
              echo
              echo "\"Portainer is a lightweight management UI which allows you to"
              echo "easily manage your different Docker environments (Docker hosts or"
              echo "Swarm clusters).\""
              ;;
            ntopng)
              echo "https://github.com/ntop/ntopng"
              echo                 
              echo "\"ntopng is the next generation version of the original ntop,"
              echo "a network traffic probe that monitors network usage. ntopng is"
              echo "based on libpcap and it has been written in a portable way in order"
              echo "to virtually run on every Unix platform, MacOSX and on Windows as well."
              echo "Educational users can obtain commercial products at no cost please see here:"
              echo "https://www.ntop.org/support/faq/do-you-charge-universities-no-profit-and-research/\""
              ;;
          esac
          ;;

        # local and tor url
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
            echo "usage: $(basename "$0") services <service_name> url [local | tor | both]"
          fi
          ;;

        port)
          get_port $service_name
          ;;

        *)
          echo "unknown command"
          ;;
      esac
    fi
  fi
}

# list all services found in /templates/services
function find_available_services {
  local service_name available_formats
  service_name="$1"
  available_formats=$(find "$TEMPLATES/services/$service/"* -exec basename {} \; | tr '\n' "|" | sed '$s/|$//')
  echo "$service [$available_formats]"
}

function create_yml {
  if bash $TEMPLATES/services/${1}/${1}_yml.sh ; then
    echo "yml file created"
  else
    echo "error creating yml file"
    exit 1
  fi
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
  local image_size free_space
  image_size=$(curl -s -H "Authorization: JWT " "https://hub.docker.com/v2/repositories/${1}/tags/?page_size=100" | jq -r '.results[] | select(.name == "latest") | .images[0].size')
  free_space=$(df -Ph /var/lib/docker | awk 'END {print $4}' | numfmt --from=iec)

  if (( image_size > free_space )); then
    echo "image size:" $image_size
    echo "free space:" $free_space
    echo "not enough free space"
    exit 1
  fi
}

# tor status and port check
function check_tor {
  local port
  port="$1"
  if [ "$(tor status)" = "active" ]; then
    echo "tor active"
    if ! tor list | grep -w $port; then
      echo "adding port ${port}"
      tor add $port
    fi
  fi
}

# get port number for specified service
function get_port {
  local service_name
  service_name="$1"

  case "$service_name" in
    planet)
      echo "80"
      echo "2200"
      ;;
    kolibri)
      echo "8080"
      ;;
    nextcloud)
      echo "8081"
      ;;
    pihole)
      echo "8053"
      ;;
    moodle)
      echo "8082"
      ;;
    privatebin)
      echo "8083"
      ;;
    portainer)
      echo "9000"
      ;;
    ntopng)
      echo "8090"
      ;;
    *)
      echo "unknown service"
      ;;
  esac
}

function services_help {
  echo
  echo "Available Services:"
  echo
  echo "  Planet"
  echo "  Kolibri"
  echo "  Nextcloud"
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
  echo "    $(basename "$0") services <service_name> up"
  echo "                             ..... down"
  echo "                             ..... start"
  echo "                             ..... stop"
  echo "                             ..... autorun [true|false]"
  echo "                             ..... ps"
  echo "                             ..... url <local|tor|both>"
  echo "                             ..... port"
  echo "                             ..... info"
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
