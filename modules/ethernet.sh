#!/bin/bash

function ethernet {

  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
    echo "Error: argument(s) missing"
    exit 1
  fi

  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces
  cp "$TEMPLATES/network/eth0/static" /etc/network/interfaces.d/eth0
  sed -i "s/IPADDRESS/$1/g" /etc/network/interfaces.d/eth0
  sed -i "s/NETMASK/$2/g" /etc/network/interfaces.d/eth0
  sed -i "s/GATEWAY/$3/g" /etc/network/interfaces.d/eth0
  sed -i "s/DNS/$4/g" /etc/network/interfaces.d/eth0
  restart_ethernet >"$LOGFILE" 2>"$LOGFILE"

  echo "static ethernet" > /etc/network/mode

  echo "This pirateship has anchored successfully!"
}

function ethernet_help {
  echo
  echo "Usage: $BASENAME ethernet <ip> <mask> <gateway> <dns>"
  echo
  echo "Configures ethernet interface (eth0) to use a static ip address"
  echo
  echo "Example:"
  echo "  $BASENAME ethernet 192.168.1.101 255.255.255.0 192.168.1.1 9.9.9.9"
  echo "      Sets the ethernet interface IP address to 192.168.1.101, mask 255.255.255.0, gateway 192.168.1.1, DNS 9.9.9.9"
  echo
}
