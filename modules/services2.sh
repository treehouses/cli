#!/bin/bash

function services2 {
  service_name="$1"
  command="$2"
  command_option="$3"
  # service_file="$TEMPLATES/services/$service_name/$output"

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
        # create yml file
        create)
          # check if yml file exists
          if [ -e /srv/${service_name}/${service_name}.yml ]; then
            echo "yml file already exists"
          else
            bash $TEMPLATES/services/${service_name}/${service_name}_yml.sh
            echo "yml file created"
          fi
          ;;

        # docker-compose up (build and create container) with given port number
        # port number MUST MATCH with port given in yml file
        up)
          if [ -z "$command_option" ]; then
            echo "no port given"
            # exit 1
          else
            treehouses tor add "$command_option"
            case "$service_name" in
              planet)
                docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -p planet up -d
                echo "service built and started"
                ;;
              kolibri)
                docker-compose -f /srv/kolibri/kolibri.yml -p kolibri up -d
                echo "service built and started"
                ;;
              *)
                echo "unknown service"
                ;;
            esac
          fi
          ;;

        # docker-compose down (stop and remove container)
        down)
          # check if yml file exists
          if [ ! -e /srv/${service_name}/${service_name}.yml ]; then
            echo "yml file doesn't exist"
          else
            docker-compose -f /srv/${service_name}/${service_name}.yml down
            echo "service stopped and removed"
          fi
          ;;

        # docker start (starts a stopped container)
        start)
          # check if container exists
          if [ "$(docker ps -a | grep $service_name)" ]; then
            docker-compose -f /srv/${service_name}/${service_name}.yml start
            echo "service started"
          else
            echo "service not found"
          fi
          ;;

        # docker stop (stops a running container)
        stop)
          # check if container exists
          if [ "$(docker ps -a | grep $service_name)" ]; then
            docker-compose -f /srv/${service_name}/${service_name}.yml stop
            echo "service stopped"
          else
            echo "service not found"
          fi
          ;;

        # autorun, autorun true, autorun false
        autorun)
          # if no command_option, then output true or false
          if [ -z "$command_option" ]; then
            # if no autorun file, output false
            if [ ! -e /boot/autorun ]; then
              echo "false"
            # else check autorun file for autorun line
            else
              tf_flag=false
              for line in $(cat /boot/autorun); do
                if [ $line = *"$service_name"* ]; then
                  tf_flag= true
                  break
                fi
              done
              if [ tf_flag = true ]; then
                echo "true"
              else
                echo "false"
              fi
            fi
          # if command_option = true, then make service autostart
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
            # add autorun line
            case "$service_name" in
              planet)
                {
                  echo "if [ -f /srv/planet/pwd/credentials.yml ]; then"
                  echo "  docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -f /srv/planet/pwd/credentials.yml -p planet up -d"
                  echo "else"
                  echo "  docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -p planet up -d"
                  echo "fi"
                  echo
                } >> /boot/autorun
                ;;
              kolibri)
                {
                  echo "docker-compose -f /srv/kolibri/kolibri.yml -p kolibri up -d"
                  echo
                } >> /boot/autorun
                ;;
              *)
                echo "unknown service"
                ;;
            esac
            echo "service autorun set to true"
          elif [ "$command_option" = "false" ]; then
            # if autorun file exists
            # if [ -e /boot/autorun ]; then
            #   for line in $(cat /boot/autorun); do
            #     # if [ $line = *"$service_name"* ]; then
            #     #   # remove line

            #     # fi
            #   done
            # fi
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
  echo "Usage: $(basename "$0") services2 [service_name] [available|installed|running|create|up|down|start|stop|autorun|ps]"
  echo ""
  echo "Executes the given command on the specified service"
  echo ""
  echo "Example:"
  echo ""
  echo "  $(basename "$0") services2 available | installed | running"
  echo "      Outputs the available | installed | running services"
  echo ""
  echo "  $(basename "$0") services2 planet create"
  echo "      Creates the yml file for the planet service and places it in the /srv/planet directory"
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