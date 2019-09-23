#!/bin/bash
#print id code of bluetooth, subfunction prints hostname and bluetooth id

function bluetoothid () {
  #check if bluetooth has an id
  btidfile=/etc/bluetooth-id
  if [ ! -f "${btidfile}" ]; then
    return 1
  fi

  bid=$(cat ${btidfile})  #get id of the bluetooth
  nname=$(uname -n)  #get network name

  case "$1" in
    "")
      echo "Bluetooth ID is: ${bid}"
      ;;
    "hostid")
      echo "Bluetooth's Network Host ID is: ${nname}-${bid}"
      ;;
  esac
}

function bluetoothid_help () {
  echo ""
  echo "Usage: $(basename "$0") bluetoothid [hostid]"
  echo ""
  echo "Displays Raspberry Pi's Bluetooth Host Number."
  echo "Optionally displays Networkname and ID as recieved through pairing."
  echo ""
  echo "Example:"
  echo "  $(basename "$0") bluetoothid hostid"
  echo "      treehouses-9012"
  echo ""
}
