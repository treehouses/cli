#!/bin/bash

function services {
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
      printf "%-10s %20s %-5d\n" "$i" "port" "$(get_port $i)"
    done
  else
    if [ -z "$command" ]; then
      echo "no command given"
      exit 1
    else
      case "$command" in
        # build and create container
        up)
          case "$service_name" in
            planet)
              if [ -f /srv/planet/pwd/credentials.yml ]; then
                docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -f /srv/planet/pwd/credentials.yml -p planet up -d
              else
                docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -p planet up -d
              fi
              echo "planet built and started"
              check_tor "80"
              ;;
            kolibri)
              bash $TEMPLATES/services/kolibri/kolibri_yml.sh
              echo "yml file created"

              docker-compose -f /srv/kolibri/kolibri.yml -p kolibri up -d
              echo "kolibri built and started"
              check_tor "8080"
              ;;
            nextcloud)
              docker run --name nextcloud -d -p 8081:80 nextcloud
              echo "nextcloud built and started"
              check_tor "8081"
              ;;
            pihole)
              bash $TEMPLATES/services/pihole/pihole_yml.sh
              echo "yml file created"

              service dnsmasq stop
              docker-compose -f /srv/pihole/pihole.yml -p pihole up -d
              echo "pihole built and started"
              check_tor "8053"
              ;;
            moodle)
              bash $TEMPLATES/services/moodle/moodle_yml.sh
              echo "yml file created"

              docker-compose -f /srv/moodle/moodle.yml -p moodle up -d
              echo "moodle built and started"
              check_tor "8082"
              ;;
            privatebin)
              bash $TEMPLATES/services/privatebin/privatebin_yml.sh
              echo "yml file created"

              docker-compose -f /srv/privatebin/privatebin.yml -p privatebin up -d
              echo "privatebin built and started"
              check_tor "8083"
              ;;
            portainer)
              docker volume create portainer_data
              docker run --name portainer -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
              echo "portainer built and started"
              check_tor "9000"
              ;;
            *)
              echo "unknown service"
              ;;
          esac
          ;;

        # stop and remove container
        down)
          case "$service_name" in
            planet|kolibri|pihole|moodle|privatebin)
              if [ ! -e /srv/${service_name}/${service_name}.yml ]; then
                echo "yml file doesn't exit"
              else
                docker-compose -f /srv/${service_name}/${service_name}.yml down
                echo "${service_name} stopped and removed"
              fi
              ;;
            nextcloud|portainer)
              docker stop $service_name
              docker rm $service_name
              echo "${service_name} stopped and removed"
              ;;
            *)
              echo "unknown service"
              ;;
          esac
          ;;

        # start a stopped container
        start)
          case "$service_name" in
            planet|kolibri|pihole|moodle|privatebin)
              if docker ps -a | grep -q $service_name; then
                docker-compose -f /srv/${service_name}/${service_name}.yml start
                echo "${service_name} started"
              else
                echo "service not found"
              fi
              ;;
            nextcloud|portainer)
              docker start $service_name
              echo "${service_name} started"
              ;;
            *)
              echo "unknown service"
              ;;
          esac
          ;;

        # stop a running container
        stop)
          case "$service_name" in
            planet|kolibri|pihole|moodle|privatebin)
              if docker ps -a | grep -q $service_name; then
                docker-compose -f /srv/${service_name}/${service_name}.yml stop
                echo "${service_name} stopped"
              else
                echo "service not found"
              fi
              ;;
            nextcloud|portainer)
              docker stop $service_name
              echo "${service_name} stopped"
              ;;
            *)
              echo "unknown service"
              ;;
          esac
          ;;

        # autorun, autorun true, autorun false
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

        # docker ps (specific service)
        ps)
          docker ps -a | grep $service_name
          ;;

        # local and tor url
        url)
          if [ "$command_option" = "local" ]; then
            local_url=$(hostname -I | head -n1 | cut -d " " -f1)
            local_url+=":"
            local_url+=$(get_port $service_name)

            if [ "$service_name" = "pihole" ]; then
              local_url+="/admin"
            fi

            echo $local_url
          elif [ "$command_option" = "tor" ]; then
            tor_url=$(tor)
            tor_url+=":"
            tor_url+=$(get_port $service_name)

            if [ "$service_name" = "pihole" ]; then
              tor_url+="/admin"
            fi

            echo $tor_url
          else
            echo "unkown command"
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
  service_name="$1"
  available_formats=$(find "$TEMPLATES/services/$service/"* -exec basename {} \; | tr '\n' "|" | sed '$s/|$//')
  echo "$service [$available_formats]"
}

# tor status and port check
function check_tor {
  port="$1"
  if [ "$(treehouses tor status)" = "active" ]; then
    echo "tor active"
    if ! treehouses tor list | grep -w $port; then
      echo "adding port ${port}"
      treehouses tor add $port
    fi
  fi
}

# get port number for specified service
function get_port {
  service_name="$1"

  case "$service_name" in
    planet)
      echo "80"
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
    *)
      echo "unknown service"
      ;;
  esac
}

function services_help {
  echo
  echo "Usage: $(basename "$0") services [available|installed|running|ports|service_name] [up|down|start|stop|autorun|ps]"
  echo
  echo "Currently available services:"
  echo "  Planet"
  echo "  Kolibri"
  echo "  Nextcloud"
  echo "  Pi-hole"
  # echo "  Moodle"
  echo "  PrivateBin"
  echo "  Portainer"
  echo
  echo "commands:"
  echo "  available                   lists all available services"
  echo "  installed                   lists all installed services"
  echo "  running                     lists all running services"
  echo "  ports                       lists all ports used by services"
  echo "  up                          builds and starts the service"
  echo "  down                        stops and removes the service"
  echo "  start                       starts the service"
  echo "  stop                        stops the service"
  echo "  autorun                     outputs true if the service is set to autorun or false otherwise"
  echo "  autorun [true | false]      sets the service autorun to true | false"
  echo "  ps                          outputs the containers related to the service"
  echo
  echo "examples:"
  echo
  echo "  $(basename "$0") services available"
  echo
  echo "  $(basename "$0") services planet up"
  echo
  echo "  $(basename "$0") services planet stop"
  echo
  echo "  $(basename "$0") services planet autorun"
  echo
  echo "  $(basename "$0") services planet autorun true"
  echo
  echo "  $(basename "$0") services planet ps"
  echo
}
