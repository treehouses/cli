#!/bin/bash

function ssh {
  status=$1
  if [ "$status" = "on" ]; then
    enable_service ssh
    start_service ssh
    echo "Success: the ssh service has been started and enabled when the system boots"
  elif [ "$status" = "off" ]; then
    disable_service ssh
    stop_service ssh
    echo "Success: the ssh service has been stopped and disabled when the system boots."
  else
    echo "Error: only 'on', 'off' options are supported";
  fi
}

function ssh_help {
  echo
  echo "Usage: $BASENAME ssh <on|off>"
  echo
  echo "Enables or disables the SSH service"
  echo
  echo "Example:"
  echo "  $BASENAME ssh on"
  echo "      The SSH service will be enabled. This will allow devices on your network to be able to connect to the raspberry pi using SSH."
  echo
  echo "  $BASENAME ssh off"
  echo "      The SSH service will be disabled."
  echo
}