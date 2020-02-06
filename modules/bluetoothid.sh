#!/bin/bash

function bluetoothid () {
  #check if bluetooth has an id
  btidfile=/etc/bluetooth-id
  if [ ! -f "${btidfile}" ]; then
    echo "No ID. Bluetooth service is not on."
    exit 0
  fi

  bid=$(cat ${btidfile})  #get id of the bluetooth
  nname=$(uname -n)  #get network name

  case "$1" in
    "")
      echo "${nname}-${bid}"
      ;;
    "number")
      echo "${bid}"
      ;;
    *)
      echo "Argument not valid; leave blank or use \"number\""
      exit 1
      ;;
  esac
}

function bluetoothid_help () {
  echo
  echo "Usage: $BASENAME bluetoothid [number]"
  echo
  echo "Displays the bluetooth network name with the 4 random digits attached."
  echo "Optionally displays Bluetooth ID individually with the use of argument [number]."
  echo
  echo "Example:"
  echo "  $BASENAME bluetoothid"
  echo "      treehouses-9012"
  echo "  $BASENAME bluetoothid number"
  echo "      9012"
  echo
}
