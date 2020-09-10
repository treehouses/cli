function internet {
  checkargn $# 1

  case "$1" in
  "")
    yel=$'\e[0;33m'
    end=$' \e[0m'
    if nc -w 10 -z 8.8.8.8 53 >/dev/null 1>&2; then
      echo -e "${yel}true${end}"
      exit 0
    fi
    echo "false"
    ;;  
  "reverse")
    if ! nc -w 10 -z 8.8.8.8 53 >/dev/null 1>&2; then
      echo "Error: no internet found"
      exit 1
    fi
    info="$(curl -s ipinfo.io | grep -o '"[^"]*"\s*:\s*"[^"]*"')"
    echo "$info" | grep -E '"(ip)"'
    echo "$info" | grep -E '"(city|country|postal)"' | tr '\n' ',' | sed 's/,$/\n/' | sed 's/\",\"/\", \"/g'
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
