function message {
  #local message ip6_regex ip4_regex ip_address body
  #checkargn $# 3
  token="$1"
  #echo $2
  #channeluri="$2"
  channel="$2"
  shift
  shift
  message="$*" 
  if ! [[ -z "$message" ]]; then
    body="{\"text\":\"\n$message\"}"
   #echo $token
   #echo $channel

    curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $token"   "$channel" -d  "$body"> "$LOGFILE"
    echo "Thanks for the feedback!"
  else
    echo "No feedback was submitted."
  fi
}

function message_help {
  echo
  echo "Usage: $BASENAME message <token> <channel> <message>"
  echo
  echo "Shares feedback with the developers"
  echo
  echo "Example:"
  echo "  $BASENAME message <token> <channel> \"Hi, you are very awesome\""
  echo "     Sends a message to gitter channel" 
  echo
}
