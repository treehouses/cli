function internet {
  checkargn $# 1

  case "$1" in
  "")
    if nc -w 10 -z 8.8.8.8 53 >/dev/null 1>&2; then
      echo "true"
      exit 0
    fi
    echo "false"
    ;;
  "reverse")
    if ! nc -w 10 -z 8.8.8.8 53 >/dev/null 1>&2; then
      log_and_exit1 "Error: no internet found"
    fi
    info="$(curl -s ipinfo.io | grep -o '"[^"]*"\s*:\s*"[^"]*"')"
    ip=$(echo "$info" | grep -e '"ip": "')
    org=$(echo "$info" | grep -e '"org": "')
    country=$(echo "$info" | grep -o '"country": "[^;]*')
    city=$(echo $info | grep -o '"city": "[^;]*' | cut -d '"' -f 4)
    postal=$(echo $info | grep -o '"postal": "[^;]*' | cut -d '"' -f 4)
    timezone=$(echo $info | grep -o '"timezone": "[^;]*' | cut -d '"' -f 4)

    if [ -z "$postal" ]; then
      postal="n/a"
    fi

    echo "$ip"
    echo "$org"
    echo "$country, \"city\": \"$city\", \"postal\": \"$postal\""
    echo "\"timezone\": \"$timezone\""
    ;;
  *)
    log_help_and_exit1 "ERROR: incorrect command" internet
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
