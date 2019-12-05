#!/bin/bash

function services2 {
  service_name="$1"
  command="$2"
  command_option="$3"

  service_file="$TEMPLATES/services/$service_name/$output"

  if [ "$service_name" = "available" ]; then
    while IFS= read -r -d '' service
    do
      service=$(basename "$service")
      find_available_services "$service"
    done < <(find "$TEMPLATES/services/"* -maxdepth 1 -type d -print0)
  else
    if [ -z "$command" ]; then
      echo "no command given"
      exit 1
    else
      case "$command" in
        # create yml file
        create)
          bash $TEMPLATES/services/${service_name}/${service_name}_yml
          echo "yml file created"
          ;;

        # docker start (starts a stopped container)
        start)

          ;;

        # docker stop (stops a running container)
        stop)

          ;;

        # docker-compose up (build and create container) with given port number
        up)

          ;;

        # docker-compose down (stop and remove container)
        down)

          ;;

        # autostart, autostart true, autostart false
        autostart)

          ;;

        # docker ps -a
        installed)

          ;;

        # docker ps
        ps)

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