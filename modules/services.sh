#!/bin/bash

function services {
  service_name="$1"
  output="$2"
  install="$3"

  service_file="$TEMPLATES/services/$service_name/$output"

  if [ "$service_name" = "all" ] || [ -z "$service_name" ]; then
    while IFS= read -r -d '' service
    do
      service=$(basename "$service")
      available_formats=$(find "$TEMPLATES/services/$service/"* -exec basename {} \; | tr '\n' "|" | sed '$s/|$//')
      echo "$service [$available_formats]"
    done < <(find "$TEMPLATES/services/"* -maxdepth 1 -type d -print0)
  else
    if [ -f "$service_file" ]; then
      if [ "$install" = "install" ]; then
        if [ "$output" = "autorun" ]; then
          checkroot
          cp "$service_file" "/boot/autorun"
          echo "Service installed."
        elif [ "$output" = "autorunonce" ]; then
          checkroot
          cp "$service_file" "/boot/autorunonce"
          echo "Service installed."
        else
          echo "tbd"
        fi
      else
        cat "$service_file"
      fi
    else
      echo "service template not found"
    fi
  fi
}

function services_help {
  echo ""
  echo "Usage: $(basename "$0") services [service_name] [docker-compose|autorun|autorunonce] [install?]"
  echo ""
  echo "Outputs or install the desired service"
  echo ""
  echo "Example:"
  echo ""
  echo "  $(basename "$0") services all"
  echo "      Outputs the available services and the available formats"
  echo ""
  echo "  $(basename "$0") services planet autorun"
  echo "      Outputs the autorun file that should be used for starting planet at boot"
  echo ""
  echo "  $(basename "$0") services planet autorun install"
  echo "      Installs the autorun file required to make planet work at everyboot"
  echo ""
  echo "  $(basename "$0") services planet autorunonce"
  echo "      Outputs the autorunonce file that should be used for starting planet once at boot"
  echo ""
}