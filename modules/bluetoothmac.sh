#!/bin/bash

function bluetoothmac () {
  # Displays device MAC address is bluetooth service is active.
  BTID=/etc/bluetooth-id
  macfile=/sys/class/net/eth0/address
  if [ ! -f "${BTID}" ]; then
    echo "False"
    exit 0
  fi

  macadd=$(cat ${macfile}) # Get MAC address

  echo "${macadd}"
}

function bluetoothmac_help () {
  echo ""
  echo "Usage: $(basename "$0") bluetoothmac"
  echo ""
  echo "Displays the device's MAC address if bluetooth service is functioning."
  echo ""
  echo "Example:"
  echo "  $(basename "$0") bluetoothmac"
  echo "    e3:56:47:i8:B7:18"
  echo ""
}

