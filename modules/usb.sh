#!/bin/bash

function usb {
  command="$1"

  chmod +x $TEMPLATES/hub-ctrl

  if [ "$command" = "on" ]; then
    $TEMPLATES/hub-ctrl -h 2 -P 1 -p 1
    $TEMPLATES/hub-ctrl -h 2 -P 2 -p 1
    $TEMPLATES/hub-ctrl -h 2 -P 3 -p 1
    $TEMPLATES/hub-ctrl -h 2 -P 4 -p 1
    $TEMPLATES/hub-ctrl -h 1 -P 1 -p 1

    echo "usb ports turned on"
  elif [ "$command" = "off" ]; then
    # check for connected ethernet
    if [ "$(cat /sys/class/net/eth0/carrier)" = "1" ]; then
      read -r -p "The ethernet port on your Raspberry Pi is connected. Turning off usb power will interfere with your ethernet connection. Do you wish to continue? Y or N" yn
      case $yn in
        [Yy]*)
          ;;
        [Nn]*)
          exit
          ;;
      esac
    fi

    $TEMPLATES/hub-ctrl -h 2 -P 1 -p
    $TEMPLATES/hub-ctrl -h 2 -P 2 -p
    $TEMPLATES/hub-ctrl -h 2 -P 3 -p
    $TEMPLATES/hub-ctrl -h 2 -P 4 -p
    $TEMPLATES/hub-ctrl -h 1 -P 1 -p

    echo "usb ports turned off"
  else
    echo "unknown command"
  fi
}

function usb_help {
  echo ""
  echo "Usage: $(basename "$0") usb [on|off]"
  echo ""
  echo "Turns usb ports on or off"
  echo "Note: cannot control individual usb ports"
  echo ""
  echo "Example:"
  echo ""
  echo "  $(basename "$0") usb on"
  echo "      Turns the usb ports on"
  echo ""
  echo "  $(basename "$0") usb off"
  echo "      Turns the usb ports off"
  echo ""
}
