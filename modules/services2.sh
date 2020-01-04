#!/bin/bash

function services2 {
  service_name="$1"
  command="$2"
  command_option="$3"

  # list all services available to be installed
  if [ "$service_name" = "available" ]; then
    while IFS= read -r -d '' service
    do
      service=$(basename "$service")
      find_available_services "$service"
    done < <(find "$TEMPLATES/services/"* -maxdepth 1 -type d -print0)
  # list all installed services
  elif [ "$service_name" = "installed" ]; then
    docker ps -a
  # list all running services
  elif [ "$service_name" = "running" ]; then
    docker ps
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
              echo "adding port 80..."
              treehouses tor add 80
              if [ -f /srv/planet/pwd/credentials.yml ]; then
                docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -f /srv/planet/pwd/credentials.yml -p planet up -d
              else
                docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -p planet up -d
              fi
              echo "planet built and started"
              ;;
            kolibri)
              echo "adding port 8080..."
              treehouses tor add 8080
              bash $TEMPLATES/services/kolibri/kolibri_yml.sh
              echo "yml file created"

              docker-compose -f /srv/kolibri/kolibri.yml -p kolibri up -d
              echo "kolibri built and started"
              ;;
            nextcloud)
              echo "adding port 8081..."
              treehouses tor add 8081
              docker run --name nextcloud -d -p 8081:80 nextcloud
              echo "nextcloud built and started"
              ;;
            pihole)
              bash $TEMPLATES/services/pihole/pihole_yml.sh
              echo "yml file created"

              service dnsmasq stop
              docker-compose -f /srv/pihole/pihole.yml -p pihole up -d
              echo "pihole built and started"
              ;;
            moodle)
              echo "adding port 8082..."
              treehouses tor add 8082
              bash $TEMPLATES/services/moodle/moodle_yml.sh
              echo "yml file created"

              docker-compose -f /srv/moodle/moodle.yml -p moodle up -d
              echo "moodle built and started"
              ;;
            *)
              echo "unknown service"
              ;;
          esac
          ;;

        # stop and remove container
        down)
          case "$service_name" in
            planet)
              if [ ! -e /srv/planet/planet.yml ]; then
                echo "yml file doesn't exist"
              else
                docker-compose -f /srv/planet/planet.yml down
                echo "planet stopped and removed"
              fi
              ;;
            kolibri)
              if [ ! -e /srv/kolibri/kolibri.yml ]; then
                echo "yml file doesn't exist"
              else
                docker-compose -f /srv/kolibri/kolibri.yml down
                echo "kolibri stopped and removed"
              fi
              ;;
            nextcloud)
              docker stop nextcloud
              docker rm nextcloud
              echo "nextcloud stopped and removed"
              ;;
            pihole)
              if [ ! -e /srv/pihole/pihole.yml ]; then
                echo "yml file doesn't exist"
              else
                docker-compose -f /srv/pihole/pihole.yml down
                echo "pihole stopped and removed"
              fi
              ;;
            moodle)
              if [ ! -e /srv/moodle/moodle.yml ]; then
                echo "yml file doesn't exist"
              else
                docker-compose -f /srv/moodle/moodle.yml down
                echo "moodle stopped and removed"
              fi
              ;;
            *)
              echo "unknown service"
              ;;
          esac
        ;;

        # start a stopped container
        start)
          case "$service_name" in
            planet)
              if docker ps -a | grep -q planet; then
                docker-compose -f /srv/planet/planet.yml start
                echo "planet started"
              else
                echo "service not found"
              fi
              ;;
            kolibri)
              if docker ps -a | grep -q kolibri; then
                docker-compose -f /srv/kolibri/kolibri.yml start
                echo "kolibri started"
              else
                echo "service not found"
              fi
              ;;
            nextcloud)
              docker start nextcloud
              echo "nextcloud started"
              ;;
            pihole)
              if docker ps -a | grep -q pihole; then
                docker-compose -f /srv/pihole/pihole.yml start
                echo "pihole started"
              else
                echo "service not found"
              fi
              ;;
            moodle)
              if docker ps -a | grep -q moodle; then
                docker-compose -f /srv/moodle/moodle.yml start
                echo "moodle started"
              else
                echo "service not found"
              fi
              ;;
            *)
              echo "unknown service"
              ;;
          esac
          ;;

        # stop a running container
        stop)
          case "$service_name" in
            planet)
              if docker ps -a | grep -q planet; then
                docker-compose -f /srv/planet/planet.yml stop
                echo "planet stopped"
              else
                echo "service not found"
              fi
              ;;
            kolibri)
              if docker ps -a | grep -q kolibri; then
                docker-compose -f /srv/kolibri/kolibri.yml stop
                echo "kolibri stopped"
              else
                echo "service not found"
              fi
              ;;
            nextcloud)
              docker stop nextcloud
              echo "nextcloud stopped"
              ;;
            pihole)
              if docker ps -a | grep -q pihole; then
                docker-compose -f /srv/pihole/pihole.yml stop
                echo "pihole stopped"
              else
                echo "service not found"
              fi
              ;;
            moodle)
              if docker ps -a | grep -q moodle; then
                docker-compose -f /srv/moodle/moodle.yml stop
                echo "moodle stopped"
              else
                echo "service not found"
              fi
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

function services2_help {
  echo ""
  echo "Usage: $(basename "$0") services2 [service_name] [available|installed|running|up|down|start|stop|autorun|ps]"
  echo ""
  echo "Executes the given command on the specified service"
  echo ""
  echo "Example:"
  echo ""
  echo "  $(basename "$0") services2 available | installed | running"
  echo "      Outputs the available | installed | running services"
  echo ""
  echo "  $(basename "$0") services2 planet up"
  echo "      Builds and starts the planet service"
  echo ""
  echo "  $(basename "$0") services2 planet down"
  echo "      Stops and removes the planet service"
  echo ""
  echo "  $(basename "$0") services2 planet start | stop"
  echo "      Starts | stops the planet service"
  echo ""
  echo "  $(basename "$0") services2 planet autorun"
  echo "      Outputs true if the planet service is set to autorun or false otherwise"
  echo ""
  echo "  $(basename "$0") services2 planet autorun true | false"
  echo "      Sets the planet service autorun to true | false"
  echo ""
  echo "  $(basename "$0") services2 planet ps"
  echo "      Outputs the containers related to the planet service"
  echo ""
}