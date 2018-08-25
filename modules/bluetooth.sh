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
  elif [ "$status" = "off" ]; then
    cp "$TEMPLATES/bluetooth/default" /etc/systemd/system/dbus-org.bluez.service

    disable_service rpibluetooth
    stop_service rpibluetooth
    restart_service bluetooth

    rm -rf /etc/bluetooth-id

    sleep 3 # Wait few seconds for bluetooth to start
    restart_service bluealsa # restart the bluetooth audio service

    echo "Success: the bluetooth service has been switched to default, and the service has been stopped."
  else
    echo "Error: only 'on', 'off' options are supported";
  fi
}

function bluetooth_help {
  echo ""
  echo "Usage: $(basename "$0") bluetooth <on|off>"
  echo ""
  echo "Switches between hotspot / regular bluetooth mode"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") bluetooth on"
  echo "      This will start the bluetooth server, which lets the user control the raspberry pi using the mobile app."
  echo ""
  echo "  $(basename "$0") bluetooth off"
  echo "      This will stop the bluetooth server, and bring everything back to regular mode."
  echo ""
}
