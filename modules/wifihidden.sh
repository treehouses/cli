function wifihidden {
  hide="hidden"
  wifimain "$@"
}

function wifihidden_help {
  echo
  echo "Usage: $BASENAME wifihidden <ESSID> [password] [WPA-EAP]"
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
  echo "  $BASENAME wifihidden home homewifipassword WPA-EAP username"
  echo "      Connects to an Enterprise (WPA-EAP) hidden wifi network named 'home' with user 'username' and user password 'homewifipassword'."
  echo
}
