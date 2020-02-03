#!/bin/bash

function usb {
  # check if hub-ctrl binary exists
  if [ ! -e /usr/local/bin/hub-ctrl ]; then
    echo "required binary 'hub-ctrl' not found"
    exit 1
  fi

  # check if libusb-dev pkg is installed
  check_missing_packages libusb-dev

  command="$1"

  if [[ $(detectrpi) =~ 'RPI3' ]]; then
    if [ "$command" = "on" ]; then
      /usr/local/bin/hub-ctrl -h 1 -P 2 -p 1

      echo "usb ports turned on"
    elif [ "$command" = "off" ]; then
      /usr/local/bin/hub-ctrl -h 1 -P 2 -p

      echo "usb ports turned off"
    else
      echo "unknown command"
    fi
  elif [[ $(detectrpi) =~ 'RPI4' ]]; then
    if [ "$command" = "on" ]; then
      /usr/local/bin/hub-ctrl -h 2 -P 1 -p 1
      /usr/local/bin/hub-ctrl -h 2 -P 2 -p 1
      /usr/local/bin/hub-ctrl -h 2 -P 3 -p 1
      /usr/local/bin/hub-ctrl -h 2 -P 4 -p 1
      /usr/local/bin/hub-ctrl -h 1 -P 1 -p 1

      echo "usb ports turned on"
    elif [ "$command" = "off" ]; then
      # check for connected ethernet
      if [ "$(cat /sys/class/net/eth0/carrier)" = "1" ]; then
        read -r -p "The ethernet port on your Raspberry Pi 4 is connected. Turning off usb power will interfere with your ethernet connection. Do you wish to continue? Y or N" yn
        case $yn in
          [Yy]*)
            ;;
          [Nn]*)
            exit
            ;;
        esac
      fi
      /usr/local/bin/hub-ctrl -h 2 -P 1 -p
      /usr/local/bin/hub-ctrl -h 2 -P 2 -p
      /usr/local/bin/hub-ctrl -h 2 -P 3 -p
      /usr/local/bin/hub-ctrl -h 2 -P 4 -p
      /usr/local/bin/hub-ctrl -h 1 -P 1 -p

      echo "usb ports turned off"
    else
      echo "unknown command"
    fi
  fi
}

function usb_help {
  echo
  echo "Usage: $BASENAME usb [on|off]"
  echo
  echo "Turns usb ports on or off"
  echo "Note: cannot control individual usb ports"
  echo
  echo "Example:"
  echo
  echo "  $BASENAME usb on"
  echo "      Turns the usb ports on"
  echo
  echo "  $BASENAME usb off"
  echo "      Turns the usb ports off"
  echo
}
