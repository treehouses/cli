function uptime {
  checkrpi
  checkargn $# 0

  if $(dpkg-query -W -f='${Status}' uptimed 2>/dev/null | grep -c "ok installed") -eq 0]; then
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
