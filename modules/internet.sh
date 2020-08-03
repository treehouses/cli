function internet {
  checkargn $# 1

  case "$1" in
  "")
    if ip route get 8.8.8.8 2>/dev/null 1>&2; then
      echo "true"
      exit 0
    fi
    echo "false"
    ;;  
  "reverse")
    info="$(curl -s ipinfo.io | grep -o '"[^"]*"\s*:\s*"[^"]*"')"
    #echo $info | grep -o '"[^"]*"\s*:\s*"[^"]*"' | grep -E '"(ip)"'
    
    echo -n "$info" | grep -E '"(ip)"'
    echo -n "$info" | grep -E '"(city|country|postal)"' | tr '\n' ',' | sed 's/,$/\n/'
    echo "$info" | grep -E '"(org|timezone)"'
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
