function usb {
  local command
  checkroot
  checkargn $# 1
  # check if hub-ctrl binary exists
  check_missing_binary hub-ctrl "hub-ctrl is missing\ninstall instructions can be found in\nhttps://raw.githubusercontent.com/codazoda/hub-ctrl.c/master/hub-ctrl.c"

  # check if libusb-dev pkg is installed
  check_missing_packages libusb-dev

  command="$1"

  if [[ $(detectrpi) =~ 'RPI3' ]]; then
    case $command in
      "on")
        /usr/local/bin/hub-ctrl -h 1 -P 2 -p 1

        echo "usb ports turned on"
        ;;
      "off")
        /usr/local/bin/hub-ctrl -h 1 -P 2 -p

        echo "usb ports turned off"
        ;;
      "")
        lsusb -t
        ;;
      *)
        echo "Error: unknown command"
        usb_help
        exit 1
        ;;
    esac 
  elif [[ $(detectrpi) =~ 'RPI4' ]]; then
    case $command in
      "on")
        /usr/local/bin/hub-ctrl -h 2 -P 1 -p 1
        /usr/local/bin/hub-ctrl -h 2 -P 2 -p 1
        /usr/local/bin/hub-ctrl -h 2 -P 3 -p 1
        /usr/local/bin/hub-ctrl -h 2 -P 4 -p 1
        /usr/local/bin/hub-ctrl -h 1 -P 1 -p 1

        echo "usb ports turned on"
        ;;
      "off")
        # check for connected ethernet
        if [ "$(</sys/class/net/eth0/carrier)" = "1" ]; then
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
        ;;
      "")
        lsusb -t
        ;;
      *)
        log_help_and_exit1 "Error: unknown command" usb
        ;;
    esac
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
  echo "  $BASENAME usb"
  echo "      Prints usb device information"
  echo
  echo "  $BASENAME usb on"
  echo "      Turns the usb ports on"
  echo
  echo "  $BASENAME usb off"
  echo "      Turns the usb ports off"
  echo
}
