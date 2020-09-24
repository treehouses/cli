function bluetooth {
  local status macfile macadd btidfile bid nname
  checkrpiwireless
  checkroot
  checkargn $# 2
  status=$1

  case $status in
    "")
      if [ "$(systemctl is-active rpibluetooth.service)" = "active" ]; then
        echo "on"
      elif [ "$(systemctl is-active rpibluetooth.service)" = "failed" ]; then
        echo "crashed"
      elif [ "$(systemctl is-active rpibluetooth.service)" = "activating" ]; then
        echo "restarting"
      else
        echo "off"
      fi
      ;;

    "status")
      if [ "$(systemctl is-active bluetooth.service)" = "active" ]; then
        echo "bluetooth service status: on"
      elif [ "$(systemctl is-active bluetooth.service)" = "failed" ]; then
        echo "bluetooth service status: failed"
      else
        echo "bluetooth service status: off"
      fi
      if [ "$(systemctl is-active rpibluetooth.service)" = "active" ]; then
        echo "rpibluetooth service status: on"
      elif [ "$(systemctl is-active rpibluetooth.service)" = "failed" ]; then
        echo "rpibluetooth service status: crashed"
      elif [ "$(systemctl is-active rpibluetooth.service)" = "activating" ]; then
        echo "rpibluetooth service status: restarting"
      else
        echo "rpibluetooth service status: off"
      fi
      ;;

    "on")
      checkargn $# 1
			echo "$TEMPLATES"
      cp "$TEMPLATES/bluetooth/hotspot" /etc/systemd/system/dbus-org.bluez.service
      enable_service rpibluetooth
      restart_service bluetooth
      restart_service rpibluetooth
      sleep 5 # wait 5 seconds for bluetooth to be completely up
      echo "Success: the bluetooth service has been started."
      ;;

    "off")
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
      ;;

    "mac")
      checkargn $# 1
      macfile=/sys/kernel/debug/bluetooth/hci0/identity
      macadd=$(cat ${macfile})
      echo "${macadd:0:17}"
      ;;

    "id")
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
          log_and_exit1 "Argument not valid; leave blank or use \"number\""
          ;;
      esac
      ;;
      
    "button")
      checkargn $# 1
      button bluetooth
      ;;

    "log")
      if [ "$2" = "" ]; then
        checkargn $# 1
        journalctl -u rpibluetooth -u bluetooth --no-pager
      elif [ "$2" = "follow" ]; then
        echo "press (ctrl + c) to exit"
        journalctl -u rpibluetooth -u bluetooth -f
			elif [ "$2" = "on" ]; then
				config update bluetoothlog 1
				echo "run treehouses bluetooth restart for changes to take effect"
			elif [ "$2" = "off" ]; then
				config update bluetoothlog 0
				echo "run treehouses bluetooth restart for changes to take effect"
      else
        log_and_exit1 "Argument not valid; leave blank or use \"follow\""
      fi
      ;;

    "restart")
      bluetooth off &>"$LOGFILE"
      bluetooth on &>"$LOGFILE"
      echo "Success: the bluetooth service has been restarted."
      ;;

    "pause")
      checkargn $# 1
      cp "$TEMPLATES/bluetooth/default" /etc/systemd/system/dbus-org.bluez.service
      disable_service rpibluetooth
      stop_service rpibluetooth
      restart_service bluetooth
      sleep 3 # Wait few seconds for bluetooth to start
      restart_service bluealsa # restart the bluetooth audio service
      echo "Success: the bluetooth service has been switched to default, and the service has been stopped."
      ;;

    *)
      echo "Error: only 'on', 'off', 'pause', 'restart', 'mac', 'id', 'button', 'log', and 'status' options are supported";
      ;;
  esac
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
}
