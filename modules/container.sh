#!/bin/bash

function container {
  container=$1
  if [ "$container" = "docker" ]; then
    disable_service balena
    stop_service balena
    enable_service docker
    start_service docker
    echo "Success: docker has been enabled and started."
  elif [ "$container" = "balena" ]; then
    disable_service docker
    stop_service docker
    enable_service balena
    start_service balena
    echo "Success: balena has been enabled and started."
  elif [ "$container" = "none" ]; then
    disable_service balena
    disable_service docker
    stop_service docker
    stop_service balena
    echo "Success: docker and balena have been disabled and stopped."
  else
    echo "Error: only 'docker', 'balena', 'none' options are supported";
  fi
}

function container_help {
  echo ""
  echo "Usage: $(basename "$0") container <docker|balena|none>"
  echo ""
  echo "Starts the desired container."
  echo ""
  echo "Example:"
  echo "  $(basename "$0") container docker"
  echo "      This will start and enable the docker service. The balena service will be stopped and disabled."
  echo ""
  echo "  $(basename "$0") container balena"
  echo "      This will start and enable the balena service. The docker service will be stopped and disabled."
  echo ""
  echo "  $(basename "$0") container none"
  echo "      This will stop and disable the balena and docker service."
  echo ""
}