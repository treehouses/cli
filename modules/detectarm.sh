function detectarm {
  checkargn $# 0
  if [ "$(detectrpi)" = "nonrpi" ]; then
    echo "rpi required"
    exit 1
  else
    cat /proc/cpuinfo | grep "model name" | grep -oP '(?<=\().*(?=\))' -m1
  fi
}


function detectarm_help {
  echo
  echo "Usage: $BASENAME detectarm"
  echo
  echo "Detects and outputs arm version"
  echo
  echo "Example:"
  echo "  $BASENAME detectarm"
  echo "      Prints arm version"
  echo
}
