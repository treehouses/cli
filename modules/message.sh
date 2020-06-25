function message {
  #local message ip6_regex ip4_regex ip_address body
  #checkargn $# 3
  token="$1"
  #echo $2
  #channeluri="$2"
  channelid="$2"
  shift
  shift
  message="$*" 
  if ! [[ -z "$message" ]]; then
    body="{\"text\":\"\n$message\"}"
   #echo $token
   #echo $channelid
   channel=https://api.gitter.im/v1/rooms/$channelid/chatMessages
    curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $token"   "$channel" -d  "$body"> "$LOGFILE"
    echo "Thanks for the feedback!"
  else
    echo "No feedback was submitted."
  fi
}

function message_help {
  echo
  echo "Usage: $BASENAME message <token> <channelid> <message>"
  echo
  echo "You can get your token from https://developer.gitter.im/docs/welcome by signing in, it should show up immediately or by navigating to https://developer.gitter.im/apps"
  echo
  echo "You can get the id of the channel you want to message by going to https://api.gitter.im/v1/rooms?access_token=<your token> and find your channel id labelled \"id\": in the json response"
  echo
  echo "Shares feedback with the developers"
  echo
  echo "Example:"
  echo "  $BASENAME message <token> <channelid> \"Hi, you are very awesome\""
  echo "     Sends a message to gitter channel" 
  echo
}
