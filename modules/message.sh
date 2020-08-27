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
    telegram)
      check_missing_binary telegram-cli
      case "$2" in
        sendto)
          #path=$(which telegram-cli)
          #echo "use 'git clone https://github.com/vysheng/tg --recursive' into the root directory"
          #if [ -e /root/tg/bin/telegram-cli ]; then
          #if [ -e $path ]; then
          contact=$3
          shift; shift; shift;
          message=$*
            #./bin/telegram-cli -W server.pub -e "msg $contact '$message'"
          telegram-cli -W server.pub -e "msg $contact '$message'" >/dev/null 2>&1
          #fi
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
  echo "For Telegram, you must follow these install instructions: "
  echo
  echo "apt install libreadline-dev libconfig-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libssl1.0-dev libgcrypt20-dev"
  echo "git clone https://github.com/vysheng/tg --recursive"
  echo "cd tg"
  echo "sed -i '107d' ./tgl/mtproto-utils.c"
  echo "sed -i '101d' ./tgl/mtproto-utils.c"
  echo "sed -i \"s/\\-rdynamic //\" Makefile.in"
  echo "sed -i \"s/\\-fPIC//\" Makefile.in"
  echo "sed -i \"s/\\-Werror //\" Makefile.in"
  echo "./configure"
  echo "make"
  echo "cp ./bin/telegram-cli /usr/local/bin/."
  echo
  echo "You can get your token from https://developer.gitter.im/docs/welcome by signing in, it should show up immediately or by navigating to https://developer.gitter.im/apps"
  echo
  echo "You must set your api key at least once every session before sending a message"
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
  echo "  $BASENAME message telegram sendto contact \"Hi, you are very awesome\"" 
  echo "     Sends a message to a Telegram contact"
  echo
}
