function uptime {
  checkrpi
  checkargn $# 0

  if [! dpkg -s uptimed >/dev/null 2>&1]; then
    sudo apt-get install uptimed
    uptime
  else
    uptime
  fi
}

function uptime_help {
  echo "Usage: $BASENAME uptime"
  echo
  echo "Example:"
  echo "  $BASENAME uptime"
  echo "      This returns the uptime of the Raspberry Pi"
  echo

}
