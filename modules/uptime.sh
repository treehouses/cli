function uptime {
  checkrpi
  checkargn $# 0

  if ! dpkg-query -W -f='${Status}' uptimed | grep "ok installed";
  then
    sudo apt-get install uptimed
    command uptime
  else
    command uptime
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
