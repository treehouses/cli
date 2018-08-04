#!/bin/bash

function rename () {
  CURRENT_HOSTNAME=$(< /etc/hostname tr -d " \\t\\n\\r")
  echo "$1" > /etc/hostname
  sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\\t$1/g" /etc/hosts
  hostname "$1"
  echo "Success: the hostname has been modified"
}

function rename_help () {
  echo ""
  echo "Usage: $(basename "$0") rename <hostname>"
  echo ""
  echo "Changes the hostname"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") rename rpi"
  echo "      Sets the hostname to 'rpi'."
  echo ""
}