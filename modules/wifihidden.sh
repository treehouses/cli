function wifihidden {
  hide="hidden"
  wifimain "$@"
}

function wifihidden_help {
  echo
  echo "Usage: $BASENAME wifihidden <ESSID> [password]"
  echo
  echo "Connects to a hidden wifi network"
  echo
  echo "Example:"
  echo "  $BASENAME wifihidden home homewifipassword"
  echo "      Connects to a hidden wifi network named 'home' with password 'homewifipassword'."
  echo
  echo "  $BASENAME wifihidden yourwifiname"
  echo "      Connects to a hidden open wifi network named 'yourwifiname'."
  echo
}
