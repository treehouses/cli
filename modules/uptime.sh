function uptime {
  checkrpi
  check_missing_packages uptimed
  checkargn $# 1

  if [[ $1 == "" ]]; then
    command uptime 
  elif [ $1 == "boot" ]; then
    echo "Raspberry Pi booted at:"
    command uptime -s
  else
    echo "Unknown operation provided."  
  fi  
}

function uptime_help {
  echo "Usage: $BASENAME uptime [boot]"
  echo
  echo "Example:"
  echo "  $BASENAME uptime"
  echo "      This returns the uptime of the Raspberry Pi"
  echo
  echo "  $BASENAME uptime boot"
  echo "      This returns when the Raspberry Pi was booted"
  echo

}
