function internet {
  checkargn $# 0
  if ip route get 8.8.8.8 2>/dev/null 1>&2; then
    echo "true"
    exit 0
  fi
  echo "false"
}

function internet_help {
  echo
  echo "Usage: $BASENAME internet"
  echo
  echo "Outputs true if the rpi can reach internet, or false if it doesn't"
  echo
  echo "Example:"
  echo "  $BASENAME internet"
  echo "      the rpi has access to internet -> output: true"
  echo "      the rpi doesn't have access to internet -> output: false"
  echo
}
