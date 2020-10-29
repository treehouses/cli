function uptime {
  checkrpi
  check_missing_packages uptimed
  checkargn $# 1

  case $1 in
    "")
      command uptime
      ;;
    "boot")
      echo "Raspberry Pi booted at:"
      command uptime -s
      ;;
    "stop")
      systemctl stop uptimed
      ;;
    "start")
      systemctl start uptimed
      ;;
    "log")
      echo "Uptime records:"
      uprecords
      ;;
    *)
      log_help_and_exit1 "Error: unknown operation provided" uptime
      ;;
  esac
}

function uptime_help {
  echo "Usage: $BASENAME uptime [boot|start|stop|log]"
  echo
  echo "Example:"
  echo "  $BASENAME uptime"
  echo "      This returns the uptime of the Raspberry Pi"
  echo
  echo "  $BASENAME uptime boot"
  echo "      This returns when the Raspberry Pi was booted"
  echo
  echo "  $BASENAME uptime start"
  echo "      This starts Uptimed in the background"
  echo
  echo "  $BASENAME uptime stop"
  echo "      This stops Uptimed from running in the background"
  echo
  echo "  $BASENAME uptime log"
  echo "      This returns the uptime records"
  echo
}
