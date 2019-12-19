#!/bin/bash

function container_check {
  if [ "$(which balena)" ]; then
	  echo 'balena is installed'
  else
	  echo 'balean is not installed'
  fi

  if [ "$(which docker)" ]; then
	  echo 'docker is installed'
  else
	  echo 'docker is not installed'
  fi
}

function container {
  container_check
  if [ "$1" == "docker" ] ; then
    container_docker;
    exit 0
  fi

  if [ "$1" == "balena" ] ; then
    container_balena;
    exit 0
  fi

  if [ "$1" == "none" ] ; then
    container_none;
    exit 0
  fi
  
  if [ "$(systemctl is-enabled docker)" == "enabled" ] ; then
    echo "docker";
    exit 0
  fi
  
  if [ "$(systemctl is-enabled balena)" == "enabled" ] ; then
    echo "balena";
    exit 0
  fi
  
  if [ "$(systemctl is-enabled docker)" == "disabled" ] && [ "$(systemctl is-enabled balena)" == "disabled" ] ; then
    echo "none";
    exit 0
  fi
}

function container_docker {
    disable_service balena
    stop_service balena
    enable_service docker
    start_service docker
    echo "Success: docker has been enabled and started."
}

function container_balena {
    disable_service docker
    stop_service docker
    enable_service balena
    start_service balena
    echo "Success: balena has been enabled and started."
}

function container_none {
    disable_service balena
    disable_service docker
    stop_service docker
    stop_service balena
    echo "Success: docker and balena have been disabled and stopped."
}

function container_help {
  echo ""
  echo "Usage: $(basename "$0") container <docker|balena|none>"
  echo ""
  echo "Starts the desired container."
  echo ""
  echo "Example:"
  echo "  $(basename "$0") container"
  echo "      This will identify whether docker, balena or none of the services is currently running."
  echo ""
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
