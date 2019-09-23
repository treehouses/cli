#!/bin/bash
#print id code of bluetooth, subfunction prints hostname and bluetooth id

function bluetoothid () {
  #echo the id of the bluetooth
  bid=$(cat /etc/bluetooth-id)
  id=${bid}

  #echo network name with bluetooth id
  nname=$(uname -n)
  name=${nname}

  case "$1" in
    "")
      echo "Raspberry Pi's ID is: ${id}"
      ;;
    "hostid")
      echo "Raspberry Pi's network Host ID is: ${name}-${id}"
      ;;
  esac
}

function bluetoothid_help () {
  echo ;
  echo "        Usage: $(basename "$0") bluetoothid [hostid]" ;
  echo ;
  echo "                Displays Raspberry Pi's Bluetooth Host Number." ;
  echo "          Optionally displays Networkname and ID as recieved through pairing." ;
  echo ;
  echo "        Example:" ; "   $(basename "$0") bluetoothid hostid" ;
  echo ;
  echo "                treehouses-9012" ;
}
