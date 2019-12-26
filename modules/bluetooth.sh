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

  else
    echo "Error: only 'on', 'off', 'pause' options are supported";
  fi
}

function bluetooth_help {
  echo ""
  echo "Usage: $(basename "$0") bluetooth <on|off|pause>"
  echo ""
  echo "Switches between hotspot / regular bluetooth mode"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") bluetooth on"
  echo "      This will start the bluetooth server, which lets the user control the raspberry pi using the mobile app."
  echo ""
  echo "  $(basename "$0") bluetooth off"
  echo "      This will stop the bluetooth server, and bring everything back to regular mode."
  echo "      This will also remove the bluetooth device id."
  echo ""
  echo "  $(basename "$0") bluetooth pause"
  echo "      Performs the same as '$(basename "$0") bluetooth off'"
  echo "      The only difference is that this command will not remove the bluetooth device id."
  echo ""
}
