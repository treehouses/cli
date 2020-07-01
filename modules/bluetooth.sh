function bluetooth {
  local status macfile macadd btidfile bid nname
  checkrpiwireless
  checkroot
  checkargn $# 2
  status=$1

  if [ -z "$status" ]; then
    if [[ "$(service rpibluetooth status | grep "Active:")" =~ "running" ]]; then
      echo "on"
    else
      echo "off"
    fi

  elif [ "$status" = "status" ]; then
    if [[ "$(service bluetooth status | grep "Active:")" =~ "running" ]]; then
      echo "bluetooth service status: on"
    else
      echo "bluetooth service status: off"
    fi
    if [[ "$(service rpibluetooth status | grep "Active:")" =~ "running" ]]; then
      echo "rpibluetooth service status: on"
    else
      echo "rpibluetooth service status: off"
    fi

  elif [ "$status" = "on" ]; then
    checkargn $# 1
    cp "$TEMPLATES/bluetooth/hotspot" /etc/systemd/system/dbus-org.bluez.service
    enable_service rpibluetooth
    restart_service bluetooth
    restart_service rpibluetooth
    sleep 5 # wait 5 seconds for bluetooth to be completely up
    echo "Success: the bluetooth service has been started."

  elif [ "$status" = "off" ] || [ "$status" = "pause" ]; then
    checkargn $# 1
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
    checkargn $# 1
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

   elif [ "$status" = "button" ]; then
     checkargn $# 1
     button bluetooth

   elif [ "$status" = "log" ]; then
     if [ "$2" = "" ]; then
       checkargn $# 1
       journalctl -u rpibluetooth -u bluetooth --no-pager
     elif [ "$2" = "follow" ]; then
       echo "press (ctrl + c) to exit"
       journalctl -u rpibluetooth -u bluetooth -f
     elif [ "$2" = "on" ]; then
       sed -i 's/logging.ERROR/logging.DEBUG/g' /usr/local/bin/bluetooth-server.py
       bluetooth restart &>"$LOGFILE"
     elif [ "$2" = "off" ]; then
       sed -i 's/logging.DEBUG/logging.ERROR/g' /usr/local/bin/bluetooth-server.py
       bluetooth restart &>"$LOGFILE"
     else
       echo "Argument not valid; leave blank or use \"follow\""
       exit 1
     fi

   elif [ "$status" = "restart" ]; then
     bluetooth off &>"$LOGFILE"
     bluetooth on &>"$LOGFILE"
     echo "Success: the bluetooth service has been restarted."

  else
    echo "Error: only 'on', 'off', 'pause', 'restart', 'mac', 'id', 'button', 'log', and 'status' options are supported";
  fi
}

function bluetooth_help {
  echo
  echo "Usage: $BASENAME bluetooth [on|off|pause|restart|mac|id|button|status|log]"
  echo
  echo "Switches between hotspot / regular bluetooth mode, or displays the bluetooth mac address"
  echo
  echo "Example:"
  echo "  $BASENAME bluetooth"
  echo "      on"
  echo
  echo "  $BASENAME bluetooth status"
  echo "      bluetooth service status: on"
  echo "      rpibluetooth service status: on"
  echo 
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
  echo "  $BASENAME bluetooth restart"
  echo "      This will restart the bluetooth server using $BASENAME bleutooth 'off' and 'on'"
  echo
  echo "  $BASENAME bluetooth mac"
  echo "      This will display the bluetooth MAC address"
  echo
  echo "  $BASENAME bluetooth id"
  echo "      This will display the network name along with the bluetooth id number"
  echo 
  echo "  $BASENAME bluetooth button"
  echo "      When the GPIO pin 18 is on the bluetooth will ne turned off"
  echo "      Otherwise the bluetooth mode will be changed to hotspot"
  echo
  echo "  $BASENAME bluetooth id number"
  echo "      This will display the bluetooth id number"
  echo
  echo "  $BASENAME bluetooth log"
  echo "      This will display the logs of bluetooth services"
  echo
  echo "  $BASENAME bluetooth log follow"
  echo "      This will display the logs as they come in live of the bluetooth services"
  echo "      press (ctrl + c) to exit"
  echo
  echo "  $BASENAME bluetooth log off"
  echo "      This will turn off the log for the bluetooth and restart the services"
  echo
  echo "  $BASENAME bluetooth log on"
  echo "      This will turn on the log for the bluetooth and restart the services"
  echo
}
