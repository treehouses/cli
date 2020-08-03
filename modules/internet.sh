function internet {
  checkargn $# 1

  ip route get 8.8.8.8 2>/dev/null 1>&2
  case "$1" in
  "")
    # test=$(ip route get 8.8.8.8 2>/dev/null 1>&2)
    if [ $? -ne 0 ]; then
      echo "Error: No internet"
      exit 1
    else echo "yes"
    fi
    ;;
  "reverse")
    # if ip route get 8.8.8.8 2>/dev/null 1>&2; then
    if [ $? -eq 0]; then
      echo "true"
      exit 0
    fi
    info="$(curl -s ipinfo.io)"
    echo $info | grep -o '"[^"]*"\s*:\s*"[^"]*"' | grep -E '"(ip)"'
    echo $info | grep -o '"[^"]*"\s*:\s*"[^"]*"' | grep -E '"(city|country|postal)"'| tr '\n' ',' | sed 's/,$/\n/'
    echo $info | grep -o '"[^"]*"\s*:\s*"[^"]*"' | grep -E '"(org|timezone)"'
    ;;
  *)
    echo "ERROR: incorrect command"
    internet_help
    ;;
  esac
}

function internet_help {
  echo
  echo "Usage: $BASENAME internet [reverse]"
  echo
  echo "Outputs true if the rpi can reach internet, or false if it doesn't"
  echo
  echo "Example:"
  echo "  $BASENAME internet"
  echo "      the rpi has access to internet -> output: true"
  echo "      the rpi doesn't have access to internet -> output: false"
  echo
  echo "  $BASENAME internet reverse"
  echo "      this outputs the device's internet location information"
  echo
}
