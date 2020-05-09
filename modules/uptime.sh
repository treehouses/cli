function uptime {
  checkrpi
  checkargn $1

  if [! dpkg -s uptimed]; then
    sudo apt-get install uptimed
    uptime
  else
    uptime
  fi
}

function uptime_help {
  echo "Usage: $BASENAME uptime [mode]"
  echo
  echo "Example:"
  echo "  $BASENAME uptime"
  echo "      This returns the uptime of the Raspberry Pi"
  echo

}
