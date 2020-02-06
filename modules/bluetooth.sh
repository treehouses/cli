#!/bin/bash

function bluetooth {
  status=$1

  if [ "$status" = "on" ]; then
    cp "$TEMPLATES/bluetooth/hotspot" /etc/systemd/system/dbus-org.bluez.service
    enable_service rpibluetooth
    restart_service bluetooth
    restart_service rpibluetooth
    sleep 5 # wait 5 seconds for bluetooth to be completely up
    echo "Success: the bluetooth service has been started."

  elif [ "$status" = "off" ] || [ "$status" = "pause" ]; then
    cp "$TEMPLATES/bluetooth/default" /etc/systemd/system/dbus-org.bluez.service
    disable_service rpibluetooth
    stop_service rpibluetooth
    restart_service bluetooth
    if [ "$status" = "off" ]; then
      rm -rf /etc/bluetooth-id
    fi
    sleep 3 # Wait few seconds for bluetooth to start
    restart_service bluealsa # restart the bluetooth audio service
    echo "Success: the bluetooth service has been switched to default, and the service has been stopped."

  elif [ "$status" = "mac" ]; then
    macfile=/sys/kernel/debug/bluetooth/hci0/identity
    macadd=$(cat ${macfile})
    echo "${macadd:0:17}"

  elif [ "$status" = "id" ]; then
    btidfile=/etc/bluetooth-id
    if [ ! -f "${btidfile}" ]; then
      echo "No ID. Bluetooth service is not on."
      exit 0
    fi

    bid=$(cat ${btidfile})
    nname=$(uname -n)

    case "$2" in
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

  else
    echo "Error: only 'on', 'off', 'pause' options are supported";
  fi
}

function bluetooth_help {
  echo
  echo "Usage: $BASENAME bluetooth <on|off|pause|mac|id>"
  echo
  echo "Switches between hotspot / regular bluetooth mode, or displays the bluetooth mac address"
  echo
  echo "Example:"
  echo "  $BASENAME bluetooth on"
  echo "      This will start the bluetooth server, which lets the user control the raspberry pi using the mobile app."
  echo
  echo "  $BASENAME bluetooth off"
  echo "      This will stop the bluetooth server, and bring everything back to regular mode."
  echo "      This will also remove the bluetooth device id."
  echo
  echo "  $BASENAME bluetooth pause"
  echo "      Performs the same as '$BASENAME bluetooth off'"
  echo "      The only difference is that this command will not remove the bluetooth device id."
  echo
  echo "  $BASENAME bluetooth  mac"
  echo "      This will display the bluetooth MAC address"
  echo
  echo "  $BASENAME bluetooth id"
  echo "      This will display the network name along with the bluetooth id number"
  echo
  echo "  $BASENAME bluetooth id number"
  echo "      This will display the bluetooth id number"
  echo
}
