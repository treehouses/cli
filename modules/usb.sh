#!/bin/bash

function usb {
  command="$1"

  if [ "$command" = "on" ]; then
    chmod u+x $TEMPLATES/hub-ctrl -h 2 -P 1 -p 1
    chmod u+x $TEMPLATES/hub-ctrl -h 2 -P 2 -p 1
    chmod u+x $TEMPLATES/hub-ctrl -h 2 -P 3 -p 1
    chmod u+x $TEMPLATES/hub-ctrl -h 2 -P 4 -p 1
    chmod u+x $TEMPLATES/hub-ctrl -h 1 -P 1 -p 1

    echo "usb ports turned on"
  elif [ "$command" = "off" ]; then
    chmod u+x $TEMPLATES/hub-ctrl -h 2 -P 1 -p
    chmod u+x $TEMPLATES/hub-ctrl -h 2 -P 2 -p
    chmod u+x $TEMPLATES/hub-ctrl -h 2 -P 3 -p
    chmod u+x $TEMPLATES/hub-ctrl -h 2 -P 4 -p
    chmod u+x $TEMPLATES/hub-ctrl -h 1 -P 1 -p

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
