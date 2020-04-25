function detectwifi {
  checkargn $# 0
  if iwconfig wlan0 2>&1 | grep -q "No such device"; then
    echo "false"
  else
    echo "true"
  fi
}

function detectwifi_help {
  echo 
  echo "Usage: $BASENAME detectwifi"
  echo
  echo "Detects if wifi module is available and returns true or false"
  echo
  echo "Example:"
  echo "  $BASENAME detectwifi"
  echo "  true"
  echo
}
