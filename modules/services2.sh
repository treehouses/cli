#!/bin/bash

function services2 {
  service_name="$1"
  command="$2"
  command_option="$3"


  service_file="$TEMPLATES/services/$service_name/$output"

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
  else
    if [ -z "$command" ]; then
      echo "no command given"
      exit 1
    else
      case "$command" in
        # create yml file
        create)
          bash $TEMPLATES/services/${service_name}/${service_name}_yml.sh
          echo "yml file created"
          ;;

        # docker-compose up (build and create container) with given port number
        # port number MUST MATCH with port given in yml file
        up)
          if [ -z "$command_option" ]; then
            echo "no port given"
            exit 1
          else
            treehouses tor add "$command_option"
            case "$service_name" in
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
          case "$service_name" in
            kolibri)
              docker-compose -f /srv/kolibri/kolibri.yml down
              echo "service stopped and removed"
              ;;
              # grep -A1 "down)" $TEMPLATES/services/${service_name}/${service_name}_config
            *)
              echo "unknown service"
              ;;
          esac
          ;;

        # docker start (starts a stopped container)
        start)
          # check if container exists
          if [ "$(docker ps -a | grep $service_name)" ]; then
            docker start "$service_name"
            echo "service started"
          else
            echo "service not found"
          fi
          ;;

        # docker stop (stops a running container)
        stop)
          # check if container exists
          if [ "$(docker ps -a | grep $service_name)" ]; then
            docker stop "$service_name"
            echo "service stopped"
          else
            echo "service not found"
          fi
          ;;

        # autorun, autorun true, autorun false
        autorun)

          ;;

        # docker ps (specific service)
        ps)
          docker ps -a | grep $service_name
          ;;

        *)
          echo "command not known"
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
  echo ""
  echo ""
}