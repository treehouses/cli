function detectbluetooth {
  checkargn $# 0
  if dmesg | grep -iq 'blue'; then
    echo "true"
  else
    echo "false"
  fi
}

function detectbluetooth_help {
  echo
  echo "Usage: $BASENAME detectbluetooth"
  echo
  echo "Detects if bluetooth module is available and returns true or false"
  echo
  echo "Example:"
  echo "  $BASENAME detectbluetooth"
  echo "      true"
  echo
}
