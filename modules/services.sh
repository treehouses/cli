function services {
  local service_name command command_option service results installed
  local array running port_string found local_url tor_url
  checkargn $# 3
  service_name="$1"
  command="$2"
  command_option="$3"

  # list all services available to be installed
  if [ "$service_name" = "available" ]; then
    if [ -d "$SERVICES" ]; then
      for file in $SERVICES/*
      do
        if [[ ! $file = *"README.md"* ]]; then
          echo "${file##*/}" | sed -e 's/^install-//' -e 's/.sh$//'
        fi
      done
    else
      echo "ERROR: $SERVICES directory does not exist"
      exit 1
    fi
  # list all installed services
  elif [ "$service_name" = "installed" ]; then
    if [ -z "$command" ]; then
      available=($(services available))
      for service in "${available[@]}"
      do
        if [ -d /srv/$service ]; then
          echo $service
        fi
      done
    elif [ "$command" = "full" ]; then
      docker ps -a
    else
      echo "ERROR: unknown command option"
      echo "USAGE: $BASENAME services installed <full>"
      exit 1
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
        if [[ $i == *"_"* ]]; then
          results+="${i%%_*}"
        elif [[ $i == *"-"* ]]; then
          results+="${i%%-*}"
        else
          results+=$i
        fi
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
      for j in $(seq 1 "$(services $i port | wc -l)")
      do
        port_string+=$(services $i port | sed -n "$j p")
        port_string+=" "
      done
      if [ ! -z "$port_string" ]; then
        printf "%-10s %20s %-5s\n" "$i" "port" "$(echo $port_string | xargs | sed -e 's/ /, /g')"
      fi
    done
  else
    if [ -z "$command" ]; then
      echo "ERROR: no command given"
      exit 1
    elif ! check_available_services $service_name; then
      echo "ERROR: unknown service"
      echo "try running '$BASENAME services available' to see the list of available services"
      exit 1
    else
      case "$command" in
        install)
          check_space "$service_name"
          if [ "$service_name" = "planet" ]; then
            if source $SERVICES/install-planet.sh && install ; then
              echo "planet installed"
            else
              echo "ERROR: cannot run install script"
              exit 1
            fi
          elif source $SERVICES/install-${service_name}.sh && install ; then
            retries=0
            while [ "$retries" -lt 2 ];
            do
              if ! docker-compose -f /srv/${service_name}/${service_name}.yml pull ; then
                echo "retrying pull"
                ((retries+=1))
              else
                echo "${service_name} installed"
                exit 0
              fi
            done
            echo "ERROR: cannot pull docker image"
            exit 1
          else
            echo "ERROR: cannot run install script"
            exit 1
          fi
          ;;
        up)
          if [ "$service_name" = "planet" ]; then
            if [ -f /srv/planet/pwd/credentials.yml ]; then
              if docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -f /srv/planet/pwd/credentials.yml -p planet up -d ; then
                echo "planet built and started"
              else
                echo "ERROR: cannot build planet"
                exit 1
              fi
            else
              if docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -p planet up -d ; then
                echo "planet built and started"
              else
                echo "ERROR: cannot build planet"
                exit 1
              fi
            fi
          else
            check_space $service_name
            docker_compose_up $service_name
          fi
          for i in $(seq 1 "$(services $service_name port | wc -l)")
          do
            check_tor "$(services $service_name port | sed -n "$i p")"
          done
          ;;
        down)
          if [ ! -e /srv/${service_name}/${service_name}.yml ]; then
            echo "${service_name}.yml not found"
          else
            docker-compose -f /srv/${service_name}/${service_name}.yml down
            echo "${service_name} stopped and removed"
          fi
          ;;
        start)
          if docker ps -a | grep -q $service_name; then
            docker-compose -f /srv/${service_name}/${service_name}.yml start
            echo "${service_name} started"
          else
            echo "${service_name} not found"
          fi
          ;;
        stop)
          if docker ps -a | grep -q $service_name; then
            docker-compose -f /srv/${service_name}/${service_name}.yml stop
            echo "${service_name} stopped"
          else
            echo "${service_name} not found"
          fi
          ;;
        restart)
          services $service_name stop
          services $service_name up
          ;;
        autorun)
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
                echo "ERROR: ${service_name} autorun file not found"
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
            echo "ERROR: unknown command option"
            echo "USAGE: $BASENAME services autorun <true | false>"
            exit 1
          fi
          ;;
        ps)
          docker ps -a | grep $service_name
          ;;
        url)
          if [ "$command_option" = "local" ]; then
            for i in $(seq 1 "$(services $service_name port | wc -l)")
            do
              local_url=$(networkmode info | grep -oP -m1 '(?<=ip: ).*?(?=,)')
              local_url+=":"
              local_url+=$(services $service_name port | sed -n "$i p")
              if [ "$service_name" = "pihole" ]; then
                local_url+="/admin"
              elif [ "$service_name" = "couchdb" ]; then
                local_url+="/_utils"
              fi
              echo $local_url
            done
          elif [ "$command_option" = "tor" ]; then
            for i in $(seq 1 "$(services $service_name port | wc -l)")
            do
              if [ "$(tor status)" = "active" ]; then
                tor_url=$(tor)
                tor_url+=":"
                tor_url+=$(services $service_name port | sed -n "$i p")
              fi
              if [ "$service_name" = "pihole" ]; then
                tor_url+="/admin"
              elif [ "$service_name" = "couchdb" ]; then
                tor_url+="/_utils"
              fi
              echo $tor_url
            done
          elif [ "$command_option" = "" ]; then
            services $service_name url local
            services $service_name url tor
          else
            echo "ERROR: unknown command option"
            echo "USAGE: $BASENAME services url <local | tor>"
            exit 1
          fi
          ;;
        port)
          source $SERVICES/install-${1}.sh && get_ports
          ;;
        info)
          source $SERVICES/install-${service_name}.sh && get_info
          ;;
        size)
          echo "$(source $SERVICES/install-${service_name}.sh && get_size)M"
          ;;
        cleanup)
          services $service_name autorun false
          # skip planet
          if [ "$service_name" = "planet" ]; then
            echo "planet should not be cleaned up"
            exit 0
          fi
          if [ ! -e /srv/${service_name}/${service_name}.yml ]; then
            echo "ERROR: ${service_name}.yml not found"
            exit 1
          else
            docker-compose -f /srv/${service_name}/${service_name}.yml down  -v --rmi all --remove-orphans
            echo "${service_name} stopped and removed"
          fi
          for i in $(seq 1 "$(services $service_name port | wc -l)")
          do
            port=$(services $service_name port | sed -n "$i p")
            if [ "$(tor status)" = "active" ] && (tor list | grep -w $port); then
              if [[ $(pstree -ps $$) == *"ssh"* ]]; then
                screen -dm bash -c "treehouses tor delete $port"
              else
                tor delete $port
              fi
            fi
          done
          rm -rf /srv/${service_name}
          echo "${service_name} cleaned up"
          ;;
        icon)
          if [ ! -e $SERVICES/install-${service_name}.sh ]; then
            echo "${service_name} install script not found"
          else
            source $SERVICES/install-${service_name}.sh && get_icon
          fi
          ;;
        *)
          echo "ERROR: unknown command"
          exit 1
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
  if [ ! -f /srv/${1}/${1}.yml ]; then
    echo "ERROR: /srv/${1}/${1}.yml not found"
    echo "try running '$BASENAME services ${1} install' first"
    exit 1
  elif docker-compose -f /srv/${1}/${1}.yml -p ${1} up -d ; then
    echo "${1} built and started"
  else
    echo "ERROR: cannot build ${1}"
    exit 1
  fi
}

function check_space {
  local service_size service_name free_space
  # service_size=$(curl -s -H "Authorization: JWT " "https://hub.docker.com/v2/repositories/${1}/tags/?page_size=100" | jq -r '.results[] | select(.name == "latest") | .images[0].size')
  service_name="$1"
  service_size=$(source $SERVICES/install-${service_name}.sh && get_size | numfmt --from-unit=Mi)
  free_space=$(df -Ph /var/lib/docker | awk 'END {print $4}' | numfmt --from=iec)

  if (( service_size > free_space )); then
    echo "ERROR: not enough free space"
    echo "service size:" $service_size
    echo "free space:" $free_space
    exit 1
  fi
}

function check_tor {
  if [ "$(tor status)" = "active" ]; then
    echo "tor active"
    if ! tor list | grep -w $1; then
      echo "adding port ${1}"
      if [[ $(pstree -ps $$) == *"ssh"* ]]; then
        screen -dm bash -c "treehouses tor add ${1}"
      else
        tor add $1
      fi
    fi
  fi
}

function services_help {
  echo
  echo "Available Services:"
  echo
  echo "  planet       Planet Learning is a generic learning system built in Angular & CouchDB"
  echo "  kolibri      Kolibri is a learning platform using DJango"
  echo "  nextcloud    Nextcloud is a safe home for all your data, files, etc"
  echo "  netdata      Netdata is a distributed, real-time performance and health monitoring for systems"
  echo "  mastodon     Mastodon is a free, open-source social network server"
  echo "  moodle       Moodle is a Learning management system built in PHP"
  echo "  pihole       Pi-hole is a DNS sinkhole that protects your devices from unwanted content"
  echo "  privatebin   PrivateBin is a minimalist, open source online pastebin"
  echo "  portainer    Portainer is a lightweight management UI for Docker environments"
  echo "  ntopng       Ntopng is a network traffic probe that monitors network usage"
  echo "  couchdb      CouchDB is an open-source document-oriented NoSQL database, implemented in Erlang"
  echo "  mariadb      MariaDB is a community-developed fork of the MySQL relational database management system"
  echo "  seafile      Seafile is an open-source, cross-platform file-hosting software system"
  echo
  echo
  echo "Top-Level Commands:"
  echo
  echo "  Usage:"
  echo "    $BASENAME services available"
  echo "              ..... installed [full]"
  echo "              ..... running [full]"
  echo "              ..... ports"
  echo
  echo "    available               lists all available services"
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
  echo "    $BASENAME services available"
  echo
  echo "    $BASENAME services running full"
  echo
  echo
  echo "Service-Specific Commands:"
  echo
  echo "  Usage:"
  echo "    $BASENAME services <service_name> install"
  echo "                             ..... up"
  echo "                             ..... down"
  echo "                             ..... start"
  echo "                             ..... stop"
  echo "                             ..... restart"
  echo "                             ..... autorun [true|false]"
  echo "                             ..... ps"
  echo "                             ..... url [local|tor]"
  echo "                             ..... port"
  echo "                             ..... info"
  echo "                             ..... size"
  echo "                             ..... cleanup"
  echo "                             ..... icon"
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
  echo "    restart                 restarts <service_name>"
  echo
  echo "    autorun                 outputs true if <service_name> is set to autorun or false otherwise"
  echo "        [true]                  sets <service_name> autorun to true"
  echo "        [false]                 sets <service_name> autorun to false"
  echo
  echo "    ps                      outputs the containers related to <service_name>"
  echo
  echo "    url                     lists both the local and tor url for <service_name>"
  echo "        [local]                 lists the local url for <service_name>"
  echo "        [tor]                   lists the tor url for <service_name>"
  echo
  echo "    port                    lists the ports used by <service_name>"
  echo
  echo "    info                    gives some information about <service_name>"
  echo
  echo "    size                    outputs the size of <service_name>"
  echo
  echo "    cleanup                 uninstalls and removes <service_name>"
  echo
  echo "    icon                    outputs the svg code for the <service_name>'s icon"
  echo
  echo "  Examples:"
  echo
  echo "    $BASENAME services planet up"
  echo
  echo "    $BASENAME services planet autorun"
  echo
  echo "    $BASENAME services planet autorun true"
  echo
  echo "    $BASENAME services planet url local"
  echo
}
