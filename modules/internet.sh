#!/bin/bash

function internet {
  if wget -q --spider -T 3 --no-check-certificate https://www.google.com; then
    echo "true"
    exit 0
  fi
  echo "false"
}

function internet_help {
  echo
  echo "Usage: $BASENAME internet"
  echo
  echo "Outputs true if the rpi can reach internet, or false if it doesn't"
  echo
  echo "Example:"
  echo "  $BASENAME internet"
  echo "      the rpi has access to internet -> output: true"
  echo "      the rpi doesn't have access to internet -> output: false"
  echo
}
