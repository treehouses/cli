function uptime {
  checkrpi
  check_missing_packages uptimed
  checkargn $# 1

  if [[ $1 == "" ]]; then
    command uptime
  elif [ $1 == "boot" ]; then
    echo "Raspberry Pi booted at:"
    command uptime -s
  elif [ $1 == "stop" ]; then
    systemctl stop uptimed
  elif [ $1 == "start" ]; then
    systemctl start uptimed
  else
    echo "Error: unknown operation provided"
    uptime_help
    exit 1
  fi
}

function uptime_help {
  echo "Usage: $BASENAME uptime [boot|start|stop]"
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
}