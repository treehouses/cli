#!/bin/bash

function rebootneeded {
  if [ -f "/etc/reboot-needed" ]; then
    echo "true";
    exit 0
  fi

  echo "false"
}

function rebootneeded_help {
  echo
  echo "Usage: $BASENAME rebootneeded"
  echo
  echo "Shows if a reboot is required to apply the configuration changes done by this command"
  echo
  echo "Example:"
  echo "  $BASENAME rebootneeded"
  echo "      output: true"
  echo
}
