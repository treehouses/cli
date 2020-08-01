function services {
  check_missing_binary docker-compose

  local service_name command command_option service results installed
  local array running port_string found local_url tor_url
  service_name="$1"
  command="$2"
  command_option="$3"

  case $service_name in
    "")
      echo "ERROR: no command given"
      services_help
      exit 1
      ;;
    # list all services available to be installed
    "available")
      checkargn $# 1
      if [ -d "$SERVICES" ]; then
        for file in $SERVICES/*
        do
          if [[ ! $file = *"README.md"* ]]; then
            service=$(echo "${file##*/}" | sed -e 's/^install-//' -e 's/.sh$//')
            if check_arm $service; then
              echo $service
            fi
          fi
        done
      else
        echo "ERROR: $SERVICES directory does not exist"
        exit 1
      fi
      ;;
    # list all installed services
    "installed")
      checkargn $# 2
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
      ;;
    # list all running services
    "running")
    checkargn $# 2
    if [ -z "$command" ]; then
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
    elif [ "$command" = "full" ]; then
      docker ps
    else
      echo "ERROR: unknown command option"
      echo "USAGE: $BASENAME services running <full>"
      exit 1
    fi
    ;;
  # list all ports used by services
  "ports")
    checkargn $# 1
    array=($(services available))
    for i in "${array[@]}"
    do
      port_string=""
      for j in $(seq 1 "$(source $SERVICES/install-${i}.sh && get_ports | wc -l)")
      do
        port_string+="$(source $SERVICES/install-${i}.sh && get_ports | sed -n "$j p") "
      done
      if [ ! -z "$port_string" ]; then
        printf "%-15s %15s %-5s\n" "$i" "port" "$(echo $port_string | xargs | sed -e 's/ /, /g')"
      fi
    done
    ;;
    *)
      if [ -z "$command" ]; then
        check_available_services $service_name
        running_services=($(services running))
        source $SERVICES/install-$service_name.sh && get_info
        echo
        if [ -d /srv/$service_name ]; then
          echo "status: installed"
        else
          echo "status: not installed"
        fi
        for i in "${running_services[@]}"
        do
          if [ $i == $service_name ]; then
            echo "        running"
          fi
        done
        echo "autorun: $(services $service_name autorun)"
        echo "url: $(services ${service_name} url local)" | sed ':a;N;$!ba;s/\n/\n     /g'
        echo "tor: $(services ${service_name} url tor)" | sed ':a;N;$!ba;s/\n/\n     /g'
        echo "port: $(source $SERVICES/install-$service_name.sh && get_ports)" | sed ':a;N;$!ba;s/\n/\n      /g'
        echo "size: $(source $SERVICES/install-$service_name.sh && get_size)M"
      else
        check_available_services $service_name
        case "$command" in
          install)
            checkargn $# 2
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
              while [ "$retries" -lt 5 ];
              do
                if ! docker-compose --project-directory /srv/$service_name -f /srv/${service_name}/${service_name}.yml pull ; then
                  if [ "$retries" -lt 4 ]; then
                    echo "retrying pull in 6 seconds"
                    sleep 6
                  fi
                  ((retries+=1))
                else
                  echo "${service_name} installed"
                  if [ "$(source $SERVICES/install-${service_name}.sh && uses_env)" = "true" ]; then
                    echo "modify default environment variables by running '$BASENAME services ${service_name} config edit'"
                  fi
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
            checkargn $# 2
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
              if [ "$(source $SERVICES/install-${service_name}.sh && uses_env)" = "true" ]; then
                validate_yml $service_name
              fi
              docker_compose_up $service_name
            fi
            for i in $(seq 1 "$(services $service_name port | wc -l)")
            do
              check_tor "$(services $service_name port | sed -n "$i p")"
            done
            ;;
          down)
            checkargn $# 2
            if [ ! -f /srv/${service_name}/${service_name}.yml ]; then
              echo "${service_name}.yml not found"
            else
              docker-compose --project-directory /srv/$service_name -f /srv/${service_name}/${service_name}.yml down
              remove_tor_port
              echo "${service_name} stopped and removed"
            fi
            ;;
          start)
            checkargn $# 2
            if docker ps -a | grep -q $service_name; then
              if [ ! -f /srv/${service_name}/${service_name}.yml ]; then
                echo "ERROR: /srv/${service_name}/${service_name}.yml not found"
                echo "try running '$BASENAME services ${service_name} install' first"
                exit 1
              else
                if docker-compose --project-directory /srv/$service_name -f /srv/${service_name}/${service_name}.yml start; then
                  echo "${service_name} started"
                fi
              fi
            else
              echo "ERROR: ${service_name} container not found"
              echo "try running '$BASENAME services $service_name up' first to create the container"
              exit 1
            fi
            ;;
          stop)
            checkargn $# 2
            if docker ps -a | grep -q $service_name; then
              if [ ! -f /srv/${service_name}/${service_name}.yml ]; then
                echo "ERROR: /srv/${service_name}/${service_name}.yml not found"
                echo "try running '$BASENAME services ${service_name} install' first"
                exit 1
              else
                if docker-compose --project-directory /srv/$service_name -f /srv/${service_name}/${service_name}.yml stop; then
                  echo "${service_name} stopped"
                fi
              fi
            else
              echo "ERROR: ${service_name} container not found"
              echo "try running '$BASENAME services $service_name up' first to create the container"
              exit 1
            fi
            ;;
          restart)
            checkargn $# 2
            services $service_name stop
            services $service_name up
            ;;
          autorun)
            checkargn $# 3
            if [ -z "$command_option" ]; then
              if [ ! -f /boot/autorun ]; then
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
              if [ ! -f /boot/autorun ]; then
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
                if [ ! -f /srv/${service_name}/autorun ]; then
                  echo "ERROR: ${service_name} autorun file not found"
                  echo "run \"$BASENAME services $service_name install\" first"
                  exit 1
                fi
                cat /srv/${service_name}/autorun >> /boot/autorun
              else
                sed -i "/${service_name}_autorun=false/c\\${service_name}_autorun=true" /boot/autorun
              fi
              echo "service autorun set to true"
            # stop service from autostarting
            elif [ "$command_option" = "false" ]; then
              if [ -f /boot/autorun ]; then
                # if autorun lines exist, set flag to false
                sed -i "/${service_name}_autorun=true/c\\${service_name}_autorun=false" /boot/autorun
              fi
              echo "service autorun set to false"
            else
              echo "ERROR: unknown command option"
              echo "USAGE: $BASENAME services $service_name autorun [true | false]"
              exit 1
            fi
            ;;
          ps)
            checkargn $# 2
            docker ps -a | grep $service_name
            ;;
          url)
            checkargn $# 3
            if [ "$command_option" = "local" ]; then
              base_url=$(networkmode info | grep -oP -m1 '(?<=ip: ).*')
              if [[ "$base_url" =~ "," ]]; then
                base_url=$(echo $base_url | cut -f1 -d,)
              fi

              for i in $(seq 1 "$(source $SERVICES/install-${service_name}.sh && get_ports | wc -l)")
              do
                local_url="$base_url:$(source $SERVICES/install-${service_name}.sh && get_ports | sed -n "$i p")"
                if [ "$service_name" = "pihole" ]; then
                  local_url+="/admin"
                elif [ "$service_name" = "couchdb" ]; then
                  local_url+="/_utils"
                fi
                echo $local_url
              done
            elif [ "$command_option" = "tor" ]; then
              if [ "$(tor status)" = "active" ]; then
                base_tor=$(tor)
                for i in $(seq 1 "$(source $SERVICES/install-${service_name}.sh && get_ports | wc -l)")
                do
                  tor_url="$base_tor:$(source $SERVICES/install-${service_name}.sh && get_ports | sed -n "$i p")"
                  if [ "$service_name" = "pihole" ]; then
                    tor_url+="/admin"
                  elif [ "$service_name" = "couchdb" ]; then
                    tor_url+="/_utils"
                  fi
                  echo $tor_url
                done
              fi
            elif [ "$command_option" = "" ]; then
              services $service_name url local
              services $service_name url tor
            else
              echo "ERROR: unknown command option"
              echo "USAGE: $BASENAME services $service_name url [local | tor]"
              exit 1
            fi
            ;;
          port)
            checkargn $# 2
            source $SERVICES/install-${service_name}.sh && get_ports
            ;;
          info)
            checkargn $# 2
            source $SERVICES/install-${service_name}.sh && get_info
            ;;
          size)
            checkargn $# 2
            echo "$(source $SERVICES/install-${service_name}.sh && get_size)M"
            ;;
          cleanup)
            checkargn $# 2
            services $service_name autorun false
            # skip planet
            if [ "$service_name" = "planet" ]; then
              echo "planet should not be cleaned up"
              exit 0
            fi
            if [ ! -f /srv/${service_name}/${service_name}.yml ]; then
              echo "ERROR: ${service_name}.yml not found"
              echo "try running '$BASENAME services ${service_name} install' first"
              exit 1
            else
              docker-compose --project-directory /srv/$service_name -f /srv/${service_name}/${service_name}.yml down -v --rmi all --remove-orphans
              echo "${service_name} stopped and removed"
            fi
            remove_tor_port
            rm -rf /srv/${service_name}
            echo "${service_name} cleaned up"
            ;;
          icon)
            checkargn $# 3
            if [ "$command_option" = "oneline" ]; then
              echo "$(source $SERVICES/install-${service_name}.sh && get_icon | sed 's/^[ \t]*//;s/[ \t]*$//' | tr '\n' ' ')"
            else
              source $SERVICES/install-${service_name}.sh && get_icon
            fi
            ;;
          config)
            if [ "$(source $SERVICES/install-${service_name}.sh && uses_env)" = "true" ]; then
              if [ -e /srv/$service_name/.env ]; then
                seperator="--------------------"
                case $command_option in
                  "")
                    docker-compose --project-directory /srv/$service_name -f /srv/$service_name/$service_name.yml config
                    ;;
                  "new")
                    checkargn $# 4
                    kill_spinner
                    if [ -z "$4" ]; then
                      echo "ERROR: a name is required for the new env file"
                      exit 1
                    else
                      cp /srv/$service_name/.env /srv/$service_name/$4.env
                    fi
                    while read -r -u 9 line; do
                      echo $seperator
                      newline="${line%%=*}="
                      printf "%s" $newline
                      read -r userinput
                      sed -i "/$line/c\\$newline$userinput" /srv/$service_name/$4.env
                    done 9< /srv/$service_name/.env
                    echo $seperator
                    echo "Created $4.env:"
                    cat /srv/$service_name/$4.env
                    echo $seperator
                    ;;
                  "edit")
                    kill_spinner
                    case $4 in
                      "")
                        while read -r -u 9 line; do
                          echo $seperator
                          echo "Current:"
                          echo $line
                          echo "New:"
                          newline="${line%%=*}="
                          printf "%s" $newline
                          read -r userinput
                          sed -i "/$line/c\\$newline$userinput" /srv/$service_name/.env
                        done 9< /srv/$service_name/.env
                        echo $seperator
                        echo "New config file:"
                        cat /srv/$service_name/.env
                        echo $seperator
                        ;;
                      "vim")
                        checkargn $# 4
                        vim /srv/$service_name/.env
                        ;;
                      "request")
                        checkargn $# 4
                        request="$BASENAME services $service_name config edit send "
                        while read -r -u 9 line; do
                          request+="\"${line%%=*}\" "
                        done 9< /srv/$service_name/.env
                        echo $request
                        ;;
                      "send")
                        var_count_env=$(wc -l /srv/$service_name/.env | awk '{print $1}')
                        if [ "$var_count_env" -eq "$(($# - 4))" ]; then
                          args=("$@")
                          var=4
                          while read -r -u 9 line; do
                            sed -i -e "s~$line~${line%%=*}=${args[$var]}~" /srv/$service_name/.env
                            ((var++))
                          done 9< /srv/$service_name/.env
                        else
                          echo "ERROR: received $(($# - 4)) variable(s)"
                          echo "$service_name requires $var_count_env variable(s)"
                          exit 1
                        fi
                        ;;
                      *)
                        echo "ERROR: unknown command option"
                        echo "USAGE: $BASENAME services $service_name config edit [vim|request|send]"
                        exit 1
                        ;;
                    esac
                    ;;
                  "available")
                    checkargn $# 3
                    echo $seperator
                    echo ">> currently selected .env"
                    cat /srv/$service_name/.env
                    echo $seperator
                    for file in /srv/$service_name/*
                    do
                      if [[ $file = *".env" ]]; then
                        echo $seperator
                        echo ">> ${file##*/}" | sed 's/.env$//'
                        cat $file
                        echo $seperator
                      fi
                    done
                    ;;
                  "select")
                    checkargn $# 4
                    if [ -f /srv/$service_name/$4.env ]; then
                      cp /srv/$service_name/$4.env /srv/$service_name/.env
                      echo "now using $4.env"
                    else
                      echo "ERROR: /srv/$service_name/$4.env not found"
                      exit 1
                    fi
                    ;;
                  *)
                    echo "ERROR: unknown command option"
                    echo "USAGE: $BASENAME services $service_name config [new | edit | available | select]"
                    exit 1
                    ;;
                esac
              else
                echo "ERROR: /srv/$service_name/.env not found"
                echo "try running '$BASENAME services $service_name install' first"
                exit 1
              fi
            else
              echo "$service_name does not use environment variables"
            fi
            ;;
          *)
            echo "ERROR: unknown command"
            echo "USAGE: $BASENAME services $service_name install"
            echo "                                ..... up"
            echo "                                ..... down"
            echo "                                ..... start"
            echo "                                ..... stop"
            echo "                                ..... restart"
            echo "                                ..... autorun [true|false]"
            echo "                                ..... ps"
            echo "                                ..... url [local|tor]"
            echo "                                ..... port"
            echo "                                ..... info"
            echo "                                ..... size"
            echo "                                ..... cleanup"
            echo "                                ..... icon"
            echo "                                ..... config [new|edit [vim|request|send]|available|select]"
            exit 1
            ;;
        esac
      fi
      ;;
  esac
}

function check_arm {
  arms=($(source $SERVICES/install-${1}.sh && supported_arms))
  for i in "${arms[@]}"
  do
    if [ "$(detect arch)" = "$i" ]; then
      return 0
    fi
  done
  return 1
}

function check_available_services {
  array=($(services available))
  for service in "${array[@]}"
  do
    if [ "${1}" == "$service" ]; then
      return 0
    fi
  done
  echo "ERROR: unknown service"
  echo "try running '$BASENAME services available' to see the list of available services"
  exit 1
  # return 1
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

function docker_compose_up {
  if [ ! -f /srv/${1}/${1}.yml ]; then
    echo "ERROR: /srv/${1}/${1}.yml not found"
    echo "try running '$BASENAME services ${1} install' first"
    exit 1
  elif docker-compose --project-directory /srv/${1} -f /srv/${1}/${1}.yml -p ${1} up -d ; then
    echo "${1} built and started"
  else
    echo "ERROR: cannot build ${1}"
    exit 1
  fi
}

function remove_tor_port {
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
}

function validate_yml {
  if [ ! -f /srv/${1}/.env ]; then
    echo "ERROR: /srv/${1}/.env not found"
    exit 1
  else
    while read -r line; do
      if [[ $line == *=[[:space:]]* ]] || [[ $line =~ "="$ ]]; then
        echo "ERROR: unset environment variable:"
        echo $line
        echo "try running '$BASENAME services $1 config edit' to edit environment variables"
        exit 1
      fi
    done < /srv/${1}/.env
    echo "valid yml"
  fi
}

function services_help {
  echo
  echo "Available Services:"
  echo
  echo "  planet          Planet Learning is a generic learning system built in Angular & CouchDB"
  echo "  kolibri         Kolibri is a learning platform using DJango"
  echo "  nextcloud       Nextcloud is a safe home for all your data, files, etc"
  echo "  netdata         Netdata is a distributed, real-time performance and health monitoring for systems"
  echo "  mastodon        Mastodon is a free, open-source social network server"
  echo "  moodle          Moodle is a Learning management system built in PHP"
  echo "  pihole          Pi-hole is a DNS sinkhole that protects your devices from unwanted content"
  echo "  privatebin      PrivateBin is a minimalist, open source online pastebin"
  echo "  portainer       Portainer is a lightweight management UI for Docker environments"
  echo "  ntopng          Ntopng is a network traffic probe that monitors network usage"
  echo "  couchdb         CouchDB is an open-source document-oriented NoSQL database, implemented in Erlang"
  echo "  mariadb         MariaDB is a community-developed fork of the MySQL relational database management system"
  echo "  mongodb         MongoDB is a general purpose, distributed, document-based, NoSQL database."
  echo "  seafile         Seafile is an open-source, cross-platform file-hosting software system"
  echo "  librespeed      Librespeed is a very lightweight Speedtest implemented in Javascript"
  echo "  turtleblocksjs  TurtleBlocks is an activity with a Logo-inspired graphical \"turtle\" "
  echo "  musicblocks     MusicBlocks is a programming language for exploring musical concepts in an fun way" 
  echo "  minetest        Minetest is an open source infinite-world block sandbox game engine with survival and crafting"
  echo "  invoiceninja    Invoiceninja is the leading self-host platform to create invoices."
  echo "  grocy           Grocy is web-based, self-hosted groceries and household management utility for your home"
  echo "  dokuwiki        Dokuwiki is a simple to use and highly versatile Open Source wiki software"
  echo "  bookstack       Bookstack is a free and open source Wiki designed for creating beautiful documentation"
  echo "  transmission    Transmission is a BitTorrent client with many powerful features"
  echo "  piwigo          Piwigo is a photo gallery software to publish and manage your collection of pictures"
  echo "  cloud9          Cloud9 is a complete web based IDE with terminal access"
  echo "  jellyfin        Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media"
  echo "  pylon           Pylon is a web based integrated development environment built with Node.js as a backend"
  echo "  rutorrent       Rutorrent is a popular rtorrent client with a webui for ease of use"
  echo "  webssh          Webssh is a simple web application to be used as an ssh client to connect to your ssh servers"
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
  echo "    $BASENAME services <service_name>"
  echo "                             ..... install"
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
  echo "                             ..... config [new|edit [vim|request|send]|available|select]"
  echo
  echo "    <>                      shows overview of <service_name>"
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
  echo "    config                  outputs the contents of the .yml for <service_name> with the currently configured environment variables"
  echo "        [new]                   creates a new .env file with given name"
  echo "        [edit]                  edit the .env file for <service_name>"
  echo "            [vim]                   opens vim to edit the .env file for <service_name>"
  echo "            [request]               requests the command to edit the .env file for <service_name>"
  echo "            [send]                  sends the command to edit the .env file for <service_name>"
  echo "        [available]             lists available .env files for <service_name>"
  echo "        [select]                selects given .env file to be used with <service_name>"
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
