function monitor {
  noticeType=("all" "online" "error" "none" "now")
  noticeChannel="https://api.gitter.im/v1/rooms/59d259f6d73408ce4f784672/chatMessages"
  testUrl=""
  hostName=""
  keepLog="false"
  sendNotice="all"

  while getopts ":u:h:c:n:l" option; do
    case $option in
      "u") testUrl=("$OPTARG") ;;
      "h") hostName=("$OPTARG"); fileName="$hostName" ;;
      "c") noticeChannel=("$OPTARG") ;;
      "l") keepLog="true" ;;
      "n") noticeArg=("$OPTARG")
        case " ${noticeType[@]} " in
          *" $noticeArg "*) sendNotice="$noticeArg" ;;
          *) printf "Invalid option for -%s\n" "$option" >&2; monitor_help; exit 1;;
        esac;;
      :) printf "Missing argument for -%s\n" "$OPTARG" >&1; monitor_help; exit 1;;
      *) monitor_help; exit 1;;
    esac
  done

  if [ -z "$testUrl" ]; then
    echo "Argument '-u' must be provided"
    monitor_help
    exit 1
  fi

  if [ -z "$hostName" ]; then
    fileName=$(echo "$testUrl" | sed -e 's|^[^/]*//||' -e 's|/.*$||' -e 's|:.*$||')
  fi
  
  fileName=$(echo "$fileName" | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')
  STATUS=$(curl -I -L -s -o /dev/null -w "%{http_code}" ${testUrl})

  if [ "$keepLog" == "true" ]; then
    echo "[INFO] $(date) ${hostName} ${url} statusCode: ${STATUS}" >> /var/log/$fileName.test.log
  fi

  lastLog="$(tail -1 /var/log/$fileName.status.log)"

  if ( [ "$sendNotice" == "now" ] || [ ! -f /var/log/$fileName.status.log ] || ! echo "${lastLog}" | grep "\[${STATUS}\]" ); then
    echo "[${STATUS}] $(date) ${hostName} ${url}" >> /var/log/$fileName.status.log
    if [ "$sendNotice" == "now" ] || [ "$sendNotice" == "all" ] || ([ "$sendNotice" == "error" ] && [ ! $STATUS -eq 200 ]) || ([ "$sendNotice" == "online" ] && [ $STATUS -eq 200 ]); then
      export gitter_channel="$noticeChannel"
      feedback "ALERT: ${hostName} ${testUrl} \`statusCode: ${STATUS}\` \`$(date -u +"%Y-%m-%d %H:%M:%S %Z")\`"
    fi
  fi
}

function monitor_help {
  echo
  echo "Usage: $BASENAME monitor <-u testurl> [-h hostname] [-l] [-n noticetype] [-c noticechanel]"
  echo "where:"
  echo "  -u  url to test"
  echo "  -h  name of machine"
  echo "  -l  log all request"
  echo "  -n  send notice [all|none|online|error] default all"
  echo "  -c  notice channel url"
  echo
  echo "Example:"
  echo "  $BASENAME monitor -u https://treehouses.io"
  echo "      Monitor will check url 'https://treehouses.io' and send notice when status change"
  echo
  echo "  $BASENAME monitor -u https://treehouses.io -h 'Treehouse Website' -l"
  echo "      Monitor will check url 'https://treehouses.io', keep log of all request to file and send notice when status change"
  echo
  echo "  $BASENAME monitor -u https://treehouses.io -n online"
  echo "      Monitor will check url 'https://treehouses.io', and send notice only when status change to 200"
  echo
  echo "  $BASENAME monitor -u https://treehouses.io -c https://gitter.im/v1/rooms"
  echo "      Monitor will check url 'https://treehouses.io', and send notice to specified channel"
  echo
}


