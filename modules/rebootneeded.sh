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
  echo "Usage: $(basename "$0") rebootneeded"
  echo
  echo "Shows if a reboot is required to apply the configuration changes done by this command"
  echo
  echo "Example:"
  echo "  $(basename "$0") rebootneeded"
  echo "      output: true"
  echo
}
