function message {
  chats="$1"
  case "$chats" in
    gitter)
      case "$2" in
        apikey)
          echo "navigate to https://gitter.im/login/oauth/authorize?client_id=6c3ac0766e94e8b760e372e0da66e3ac4470ff3f&response_type=code&redirect_uri=http://localhost:7000/login/callback"
          echo "Click 'Allow' and enter the code at the end of the redirect link: "
          read -r code
          api_info=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" "https://gitter.im/login/oauth/token" -d '{"client_id": "6c3ac0766e94e8b760e372e0da66e3ac4470ff3f", "client_secret": "4649fa1132fae15cff89737268046bc9e65536bc", "code": "'$code'", "redirect_uri": "http://localhost:7000/login/callback", "grant_type": "authorization_code"}')
          token_info=$(echo $api_info | python -m json.tool | jq '.access_token' | tr -d '"')
          conf_var_update "api_token" "$token_info"
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
            curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $api_token" "$channel" -d "$body"> "$LOGFILE"
            echo "Thanks for the message!"
          else
            echo "No message was submitted."
          fi
          ;;
        receivefrom)
          group="$3"
          curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $api_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}'>"$LOGFILE"
          channelinfo=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $api_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}')
          #finds channel id and removes double quotes
          channelid=$(echo $channelinfo | python -m json.tool | jq '.id' | tr -d '"')
          user_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $api_token" "https://api.gitter.im/v1/user")
          user_id=$(echo $user_info | python -m json.tool | jq '.[].id' | tr -d '"')
          i=0
          length=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $api_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems" | python -m json.tool | jq '.chat | length')
          if [ $length == 0 ];then
            echo "You have no unread messages at the moment"
          fi
          unread_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $api_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems")
          while [ "$i" -lt $length ]; do
            message_id=$(echo $unread_info | python -m json.tool | jq '.chat['$i']' | tr -d '"')
            message_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $api_token" "https://api.gitter.im/v1/rooms/$channelid/chatMessages/$message_id")
            message=$(echo $message_info | python -m json.tool | jq '.text')
            from_name=$(echo $message_info | python -m json.tool | jq '.fromUser.displayName' | tr -d '"')
            from_user=$(echo $message_info | python -m json.tool | jq '.fromUser.username' | tr -d '"') 
            sent_time=$(echo $message_info | python -m json.tool | jq '.sent' | tr -d '"')  
            #displays message
            echo "From: $from_name@$from_user"
            echo "Message: $message"
            echo "Sent: $sent_time"
            curl -X POST -s -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $api_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems" -d '{"chat":["'$message_id'"]}' > "$LOGFILE"
            i=$((i+1))
          done
          ;;
        *)
          echo "This command does not exist, please look at the following:"
          message_help
          ;;
      esac
      ;;
    hangouts)
      case "$2" in
        login)
          #if ! [ -e  ]
          pip3 install hangups > "$LOGFILE"
          hangups --manual-login --debug
          path="echo "$(which treehouses | sed 's/bin\/treehouses//')lib/node_modules/@treehouses/cli/templates""
          if ! [ -e /root/cli/templates/hangups ]; then
            $(git clone --quiet https://github.com/tdryer/hangups.git $path)
          fi
          ;;
        sendto)
          #$(source message.sh)
          #$(pip3 install hangups)
          #$(git clone https://github.com/tdryer/hangups.git /root/cli/templates/hangups)
          path="echo "$(which treehouses | sed 's/bin\/treehouses//')lib/node_modules/@treehouses/cli/templates""
          if ! [ -e /root/cli/templates/hangups ]; then
            $(git clone --quiet https://github.com/tdryer/hangups.git $path)
          #else
           # echo "already exists"
          fi
          convid="$3"
          shift; shift; shift;
          message="$*"
          if ! [[ -z "$message" ]]; then
            $(python3 /root/cli/templates/hangups/examples/send_message.py --conversation-id $convid --message-text "$message")
            echo "Thanks for the message!"
          else
            echo "No message was submitted."
          fi
          #$(cd /root/cli/templates/hangups/examples)
          #echo "pwd: " $(pwd)
          #$(python3 /root/cli/templates/hangups/examples/send_message.py --conversation-id $convid --message-text "$message")
          #$(python3 send_message.py --conversation-id $convid --message-text "$message")
          ;;
        *)
          echo "This command does not exist, please look at the following:"
          message_help
          ;;
      esac
      ;;
    *)
      echo "This command does not exist, please look at the following:"
      message_help
      ;;
  esac
}

function message_help {
  echo
  echo "Usage: $BASENAME message <chats> <apikey <key> | sendto <group> <message> | receivefrom <group>>"
  echo
  echo "You can get your token from https://developer.gitter.im/docs/welcome by signing in, it should show up immediately or by navigating to https://developer.gitter.im/apps"
  echo
  echo "You must set your api key for gitter at least once every session before sending a message"
  echo
  echo "For Hangouts, you must first use the login command and follow the instructions to login, then find the conversation id through the logs of hangups, find the location of your log files and search for conversation-id, you will have to run hangups in your terminal first"
  echo
  echo "Sends message to a chat service"
  echo
  echo "Example:"
  echo
  echo "  $BASENAME message gitter apikey \"1234567890\""
  echo "     Sets and saves API token"
  echo
  echo "  $BASENAME message gitter sendto treehouses/Lobby \"Hi, you are very awesome\""
  echo "     Sends a message to a gitter channel"
  echo
  echo "  $BASENAME message gitter receivefrom treehouses/Lobby" 
  echo "     Receives unread messages from a gitter channel"
  echo
  echo "  $BASENAME message hangouts login " 
  echo "     Follow the instructions to log into your Google Hangouts account"
  echo
  echo "  $BASENAME message hangouts sendto \"Uthskjhjkhkjahkhk\" \"Hi\"" 
  echo "     Follow the instructions to log into your Google Hangouts account"
  echo
}
