function message {
  chats="$1"
  function check_apitoken {
    channel=$1
    api_token=$(echo "$(config)" | grep "$channel" | cut -d "=" -f2)
    if [[ $api_token == "" ]] || [[ $api_token == "null" ]]; then
      return
    else
      echo "$api_token"
      exit 0
    fi
  }
  case "$chats" in
    gitter)
      case "$2" in
        apitoken)
          check_apitoken gitter_api_token
          echo "navigate to https://gitter.im/login/oauth/authorize?client_id=6c3ac0766e94e8b760e372e0da66e3ac4470ff3f&response_type=code&redirect_uri=http://localhost:7000/login/callback"
          echo "Click 'Allow' and get the code at the end of the redirect link: "
          echo "run $BASENAME message gitter authorize <code>"
          ;;
        authorize)
          check_apitoken gitter_api_token
          if [[ $3 == "" ]]; then
            echo "authorization code is missing"
          else
            code=$3
            api_info=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" "https://gitter.im/login/oauth/token" -d '{"client_id": "6c3ac0766e94e8b760e372e0da66e3ac4470ff3f", "client_secret": "4649fa1132fae15cff89737268046bc9e65536bc", "code": "'$code'", "redirect_uri": "http://localhost:7000/login/callback", "grant_type": "authorization_code"}')
            token_info=$(echo $api_info | python -m json.tool | jq '.access_token' | tr -d '"')
            conf_var_update "gitter_api_token" "$token_info"
            echo "$token_info"
          fi
          ;;
        send)
          #joins room
          group="$3"
          curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}'>"$LOGFILE"
          channelinfo=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}')
          #finds channel id and removes double quotes
          channelid=$(echo $channelinfo | python -m json.tool | jq '.id' | tr -d '"')
          shift; shift; shift;
          message="$*"
          if ! [[ -z "$message" ]]; then
            body="{\"text\":\"\n$message\"}"
            channel=https://api.gitter.im/v1/rooms/$channelid/chatMessages
            curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "$channel" -d "$body"> "$LOGFILE"
            echo "Thanks for the message!"
          else
            echo "No message was submitted."
          fi
          ;;
        receive)
          case "$3" in
            read)
              group="$4"
              curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}'>"$LOGFILE"
              channelinfo=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}')
              #finds channel id and removes double quotes
              channelid=$(echo $channelinfo | python -m json.tool | jq '.id' | tr -d '"')
              user_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/user")
              user_id=$(echo $user_info | python -m json.tool | jq '.[].id' | tr -d '"')
              i=0
              length=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems" | python -m json.tool | jq '.chat | length')
              if [ $length == 0 ];then
                echo "You have no unread messages at the moment"
              fi
              unread_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems")
              while [ "$i" -lt $length ]; do
                message_id=$(echo $unread_info | python -m json.tool | jq '.chat['$i']' | tr -d '"')
                message_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/rooms/$channelid/chatMessages/$message_id")
                message=$(echo $message_info | python -m json.tool | jq '.text')
                from_name=$(echo $message_info | python -m json.tool | jq '.fromUser.displayName' | tr -d '"')
                from_user=$(echo $message_info | python -m json.tool | jq '.fromUser.username' | tr -d '"') 
                sent_time=$(echo $message_info | python -m json.tool | jq '.sent' | tr -d '"')  
                #displays message
                echo "From: $from_name@$from_user"
                echo "Message: $message"
                echo "Sent: $sent_time"
                i=$((i+1))
              done
              ;;
            mark)
              group="$4"
              curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}'>"$LOGFILE"
              channelinfo=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}')
              #finds channel id and removes double quotes
              channelid=$(echo $channelinfo | python -m json.tool | jq '.id' | tr -d '"')
              user_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/user")
              user_id=$(echo $user_info | python -m json.tool | jq '.[].id' | tr -d '"')
              i=0
              length=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems" | python -m json.tool | jq '.chat | length')
              if [ $length == 0 ];then
                echo "You have no unread messages at the moment"
              fi
              unread_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems")
              while [ "$i" -lt $length ]; do
                message_id=$(echo $unread_info | python -m json.tool | jq '.chat['$i']' | tr -d '"')
                curl -X POST -s -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $gitter_api_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems" -d '{"chat":["'$message_id'"]}' > "$LOGFILE"
                i=$((i+1))
              done
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
      ;;
    *)
      echo "This command does not exist, please look at the following:"
      message_help
      ;;
  esac
}

function message_help {
  echo
  echo "Usage: $BASENAME message <chats> <apitoken> | <authorize> <code> | send <group> <message> | receive read|mark <group>>"
  echo
  echo "You can get your token from https://developer.gitter.im/docs/welcome by signing in, it should show up immediately or by navigating to https://developer.gitter.im/apps"
  echo
  echo "You must set your api key at least once every session before sending a message"
  echo
  echo "Sends message to a chat service"
  echo
  echo "Example:"
  echo
  echo "  $BASENAME message gitter apitoken"
  echo "     check for API token"
  echo 
  echo "  $BASENAME message gitter authorize "\"1234567890\"""
  echo "     sets and saves API token"
  echo
  echo "  $BASENAME message gitter send treehouses/Lobby \"Hi, you are very awesome\""
  echo "     Sends a message to a gitter channel"
  echo
  echo "  $BASENAME message gitter receive read treehouses/Lobby"
  echo "     Receives and displays unread messages from a gitter channel"
  echo
  echo "  $BASENAME message gitter receive mark treehouses/Lobby"
  echo "     Marks unread messages from a gitter channel to read"
  echo
}
