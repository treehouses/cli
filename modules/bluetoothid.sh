#!/bin/bash

function bluetoothid () {
  #check if bluetooth has an id
  btidfile=/etc/bluetooth-id
  if [ ! -f "${btidfile}" ]; then
    log_and_exit0 "No ID. Bluetooth service is not on."
  fi

  bid=$(cat ${btidfile})  #get id of the bluetooth
  nname=$(uname -n)  #get network name

  case "$1" in
    "")
      logit "${nname}-${bid}"
      ;;
    "number")
      logit "${bid}"
      ;;
    *)
      log_and_exit1 "Argument not valid; leave blank or use \"number\""
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
