function message {
  chats="$1"
  case "$chats" in
    gitter) 
       case "$2" in
         apikey)
           conf_var_update "api_token" "$3"
           ;;
         sendto)
           #joins room
	   group="$3"
	   curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $api_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}'>"$LOGFILE"
	   channelinfo=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $api_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}')
	   #finds channel id and removes double quotes
	   channelid=$(echo $channelinfo | python -m json.tool | jq '.id' | tr -d '"')
           shift; shift; shift;
           message="$*" 
           if ! [[ -z "$message" ]]; then
             body="{\"text\":\"\n$message\"}"
             channel=https://api.gitter.im/v1/rooms/$channelid/chatMessages
	     curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $api_token"   "$channel" -d  "$body"> "$LOGFILE"
             echo "Thanks for the message!"
           else
             echo "No message was submitted."
           fi
	     ;;
         *)
           echo "This command doesn't exist, please look at the following"
           message_help
	   ;;
       esac
       ;;
  esac
}

function message_help {
  echo
  echo "Usage: $BASENAME message <chats> <apikey <key> | sendto <group> <message>>"
  echo
  echo "You can get your token from https://developer.gitter.im/docs/welcome by signing in, it should show up immediately or by navigating to https://developer.gitter.im/apps" 
  echo
  echo "You must set your api key before sending a message"
  echo
  echo "Sends message to a chat service"
  echo
  echo "Example:"
  echo "  $BASENAME message gitter sendto treehouses/Lobby \"Hi, you are very awesome\""
  echo "     Sends a message to a gitter channel" 
  echo
}
