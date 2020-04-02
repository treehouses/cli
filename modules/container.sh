function container {
  checkroot
  checkargn $# 1
  check_missing_packages "docker-ce"
  if ! which balena &>/dev/null
  then
   echo "Missing required programs: balena"
   echo "On Debian/Ubuntu try https://www.balena.io/engine/"
   echo " ln-sr /usr/bin/balena /usr/bin/balena"
  exit 1
  fi
  case "$1" in
    docker)
      container_docker;
      ;;
    balena)
      container_balena;
      ;;
    none)
      container_none;
      ;;
    "")
      if [ "$(systemctl is-enabled docker)" == "enabled" ]; then
        echo "docker"
        return
      fi
      if [ "$(systemctl is-enabled balena)" == "enabled" ]; then
        echo "balena"
        return
      fi
      if [ "$(systemctl is-enabled docker)" == "disabled" ] && [ "$(systemctl is-enabled balena)" == "disabled" ]; then
        echo "none"
      fi
      ;;
    *)
      echo "Error: only 'docker' 'balena' 'none' options are supported"
      ;;
  esac
}

function container_docker {
  export DOCKER_HOST=""
  disable_service balena
  stop_service balena
  enable_service docker
  start_service docker
  echo "Success: docker has been enabled and started."
}

function container_balena {
  export DOCKER_HOST=localhost:2375
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
  echo
  echo "Usage: $BASENAME container <docker|balena|none>"
  echo
  echo "Starts the desired container."
  echo
  echo "Example:"
  echo "  $BASENAME container"
  echo "      This will identify whether docker, balena or none of the services is currently running."
  echo
  echo "  $BASENAME container docker"
  echo "      This will start and enable the docker service. The balena service will be stopped and disabled."
  echo
  echo "  $BASENAME container balena"
  echo "      This will start and enable the balena service. The docker service will be stopped and disabled."
  echo
  echo "  $BASENAME container none"
  echo "      This will stop and disable the balena and docker service."
  echo
}
