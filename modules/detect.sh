function detect {
  if [ "$(detectrpi)" != "nonrpi" ]; then
    logit "rpi $(detectrpi)"
  elif [ -d "/vagrant" ]; then
    if [ -f "/boot/version.txt" ]; then
      logit "vagrant $(cat /boot/version.txt)"
    else
      logit "vagrant other"
    fi
  else
    logit "other $(uname -m)"
  fi
}


function detect_help {
  echo
  echo "Usage: $BASENAME detect"
  echo
  echo "Detects and outputs the hardware info"
  echo
  echo "Example:"
  echo "  $BASENAME detect"
  echo "      Prints the hardware info"
  echo
}
