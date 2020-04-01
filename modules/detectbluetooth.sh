function detectbluetooth {
  checkargn $# 0
  if hciconfig hci0 | grep 'No such device'; then
    echo "false"
  else
    echo "true"
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
