function monitor {
  checkroot
  check_missing_packages "curl"
  if [ -z $1 ]; then
    monitor_help
    exit 1
  fi
  
  local url_regex ipv4_regex ipv6_regex file code
  
  url_regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
  ipv4_regex='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
  ipv6_regex="^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:))$"
  if [[ ! $1 =~ $url_regex ]] && [[ ! $1 =~ $ipv4_regex ]] && [[ ! $1 =~ $ipv6_regex ]]; then
    echo "Invalid url or ip address."
    exit 1
  fi 

  if [ $# -eq 1 ]; then
    curl -ILs -o /dev/null $1 -w "%{http_code}\n"
    exit 0
  fi

  case "$2" in
    start)
      checkargn $# 2
      watch -c -n 1 curl -ILs $1
      echo "Monitoring for $1 terminated." && exit 0 ;;
    log)
      file="./log-$(echo "$1" | sed -e 's|^[^/]*//||' -e 's|/.*$||' -e 's|:.*$||')-$(date '+%Y-%m-%d_%H:%M:%S')"
      if [ ! -z "$3" ]; then
        checkargn $# 3
        if [[ "$3" = */* ]]; then
          mkdir -p "$(echo $3 | cut -d "/" -f "-$(awk -F"/" '{print NF-1}' <<< "${3}")")" 2>/dev/null
        fi       
        touch "$3"
        file="$3"
      fi
      
      echo "Monitoring for $1 started."
      echo "Log file saving to $file."
      echo "press (ctrl + c) to exit"
      printf "\t\tDATE\t\t\tHTTP CODE\n" > "$file"

      while :
      do
        code="$(curl -ILs -o /dev/null $1 -w "%{http_code}\n")" || break
        printf "%s\t\t\t%s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$code" >> "$file"
        sleep 5
      done
      echo "Unable to access $1." && exit 1 ;;
    notice)
      ;;
    *)
      echo "No option as $2."
      monitor_help
      exit 1 ;;
  esac
}

function monitor_help {
  echo
  echo "Usage:  $BASENANE monitor <url> [start|log|notice]"
  echo
  echo "        $BASENAME monitor <url>          return http code of the url"
  echo
  echo "        $BASENAME monitor <url> start    start monitor various info of the url"
  echo
  echo "        $BASENAME monitor <url> log      start logging http code of the url with timestamp"
  echo
  echo "        $BASENAMe monitor <url> notice"
  echo
}