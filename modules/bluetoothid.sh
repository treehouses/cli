#!/bin/bash
#print id code of bluetooth, subfunction prints hostname and bluetooth id

function bluetoothid () {
  #check if bluetooth has an id
  btidfile=/etc/bluetooth-id
  if [ ! -f "${btidfile}" ]; then
    echo "No ID. Bluetooth service is not on."
    return 1
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
      echo "Argument not valid; leave blank or use \"hostid\""
      ;;
  esac
}

function bluetoothid_help () {
  echo ""
  echo "Usage: $(basename "$0") bluetoothid [number]"
  echo ""
  echo "Displays Raspberry Pi's Bluetooth Host ID and Number."
  echo "Optionally displays Bluetooth ID individually."
  echo ""
  echo "Example:"
  echo "  $(basename "$0") bluetoothid"
  echo "      treehouses-9012"
  echo "  $(basename "$0") bluetoothid number"
  echo "      9012"
  echo ""
}
