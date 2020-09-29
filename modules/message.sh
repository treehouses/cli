function message {
  chats="$1"
  function check_apitoken {
    channelname=$1
    access_token=$(config | grep "$channelname" | cut -d "=" -f2)
    if [[ $access_token == "" ]] || [[ $access_token == "null" ]]; then
      echo "You do not have an authorized access token"
      return 1
    else
      return 0
    fi
  }
  function get_apitoken {
    channelname=$1
    access_token=$(config | grep "$channelname" | cut -d "=" -f2)
    echo "Your API access token is $access_token"
    return 0
  }
  case "$chats" in
    gitter)
      case "$2" in
        apitoken)
          if check_apitoken gitter; then
            get_apitoken gitter
          else
            echo "To get an authorized access token"
            echo "Ensure you have logged in to your account https://gitter.im/login?action=login"
            echo "Then,navigate to https://gitter.im/login/oauth/authorize?client_id=6c3ac0766e94e8b760e372e0da66e3ac4470ff3f&response_type=code&redirect_uri=http://localhost:7000/login/callback"
            echo "Click 'Allow' and get the code at the end of the redirect link: "
            echo "run $BASENAME message gitter authorize <code>"
          fi
          ;;
        authorize)
          if [[ $3 == "" ]]; then
            echo "authorization code is missing"
          else
            code=$3
            api_info=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" "https://gitter.im/login/oauth/token" -d '{"client_id": "6c3ac0766e94e8b760e372e0da66e3ac4470ff3f", "client_secret": "4649fa1132fae15cff89737268046bc9e65536bc", "code": "'$code'", "redirect_uri": "http://localhost:7000/login/callback", "grant_type": "authorization_code"}')
            token_info=$(echo $api_info | python -m json.tool | jq '.access_token' | tr -d '"')
            conf_var_update "gitter_access_token" "$token_info"
            echo "Your API access token is $token_info"
          fi
          ;;
        send)
          if check_apitoken gitter; then
            #joins room
            if [[ $3 == "" ]]; then
              echo "Group information is missing"
              echo "$BASENAME message gitter send <group>"
            fi
            group="$3"
            curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}'>"$LOGFILE"
            channelinfo=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}')
            #finds channel id and removes double quotes
            channelid=$(echo $channelinfo | python -m json.tool | jq '.id' | tr -d '"')
             shift; shift; shift;
            message="$*"
            if ! [[ -z "$message" ]]; then
              body="{\"text\":\"\n$message\"}"
              channel=https://api.gitter.im/v1/rooms/$channelid/chatMessages
              curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "$channel" -d "$body"> "$LOGFILE"
              echo "Thanks for the message!"
            else
              echo "No message was submitted."
            fi
          else
            echo "To get access token, run $BASENAME message gitter apitoken"
            exit 1
          fi
          ;;
        receive)
          case "$3" in
            show)
              if check_apitoken gitter; then
                if [ $4 == "" ]; then
                  echo "gitter group information is missing"
                fi
              group="$4"
              curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}'>"$LOGFILE"
              channelinfo=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}')
              #finds channel id and removes double quotes
              channelid=$(echo $channelinfo | python -m json.tool | jq '.id' | tr -d '"')
              user_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user")
              user_id=$(echo $user_info | python -m json.tool | jq '.[].id' | tr -d '"')
              i=0
              length=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems" | python -m json.tool | jq '.chat | length')
              if [ $length == 0 ];then
                echo "You have no unread messages at the moment"
              fi
              unread_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems")
              while [ "$i" -lt $length ]; do
                message_id=$(echo $unread_info | python -m json.tool | jq '.chat['$i']' | tr -d '"')
                message_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms/$channelid/chatMessages/$message_id")
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
            else
              echo "To get access token, run $BASENAME message gitter apitoken"
            fi
            ;;
            read)
              if check_apitoken gitter; then
                if [ $4 == "" ]; then
                  echo "gitter group information is missing"
                fi
                group="$4"
                curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}'>"$LOGFILE"
                channelinfo=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}')
                #finds channel id and removes double quotes
                channelid=$(echo $channelinfo | python -m json.tool | jq '.id' | tr -d '"')
                user_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user")
                user_id=$(echo $user_info | python -m json.tool | jq '.[].id' | tr -d '"')
                i=0
                length=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems" | python -m json.tool | jq '.chat | length')
                if [ $length == 0 ];then
                  echo "You have no unread messages at the moment"
                fi
                unread_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems")
                while [ "$i" -lt $length ]; do
                  message_id=$(echo $unread_info | python -m json.tool | jq '.chat['$i']' | tr -d '"')
                  message_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms/$channelid/chatMessages/$message_id")
                  message=$(echo $message_info | python -m json.tool | jq '.text')
                  from_name=$(echo $message_info | python -m json.tool | jq '.fromUser.displayName' | tr -d '"')
                  from_user=$(echo $message_info | python -m json.tool | jq '.fromUser.username' | tr -d '"') 
                  sent_time=$(echo $message_info | python -m json.tool | jq '.sent' | tr -d '"')  
                  curl -X POST -s -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems" -d '{"chat":["'$message_id'"]}' > "$LOGFILE"
                  #displays message
                  echo "From: $from_name@$from_user"
                  echo "Message: $message"
                  echo "Sent: $sent_time"
                  i=$((i+1))
                done
              else
                echo "To get access token, run $BASENAME message gitter apitoken"
              fi
              ;;
            mark)
              if check_apitoken gitter; then
                group="$4"
                curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}'>"$LOGFILE"
                channelinfo=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms" -d '{"uri":"'$group'"}')
                #finds channel id and removes double quotes
                channelid=$(echo $channelinfo | python -m json.tool | jq '.id' | tr -d '"')
                user_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user")
                user_id=$(echo $user_info | python -m json.tool | jq '.[].id' | tr -d '"')
                i=0
                length=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems" | python -m json.tool | jq '.chat | length')
                if [ $length == 0 ];then
                  echo "You have no unread messages at the moment"
                fi
                unread_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems")
                while [ "$i" -lt $length ]; do
                  message_id=$(echo $unread_info | python -m json.tool | jq '.chat['$i']' | tr -d '"')
                  curl -X POST -s -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/user/$user_id/rooms/$channelid/unreadItems" -d '{"chat":["'$message_id'"]}' > "$LOGFILE"
                  i=$((i+1))
                done
              else
                echo "To get access token, run $BASENAME message gitter apitoken"
              fi
              ;;
            *)
              echo "This command does not exist, please look at the following:"
              message_help
              ;;
          esac
          ;;
        *)
          echo "this command does not exist, please look at the following:"
          message_help
          ;;
      esac
      ;;
    slack)
      case "$2" in
        apikey)
          echo "Please look at the following to see how to get the key:"
          message_help
          echo "Enter your key: "
          read -r stoken
          echo "token: $stoken"
          conf_var_update "slacktoken" "$stoken"
          ;;
        sendto)
           #token=$3
           channel=$3
           shift; shift; shift;
           message=$*
           echo "token: $stoken"
           echo "token: $slacktoken"
           echo "channel: $channel"
           echo "message: $message"
           #curl -X POST -H 'Authorization: Bearer '$token'' -H 'Content-type: application/json' https://slack.com/api/chat.postMessage --data '{  "channel": "'$channel'", "text": "$message", "as_user": true}'
           curl -X POST -H 'Authorization: Bearer '$slacktoken' ' -H 'Content-type: application/json' https://slack.com/api/chat.postMessage --data "{  \"channel\": \"$channel\", \"text\": \"$message\", \"as_user\": true}" #works
           #curl -X POST -H 'Authorization: Bearer '$token'' -H 'Content-type: application/json' 'https://slack.com/api/chat.postMessage' -d "{\"channel\": \"'$channel'\", \"text\": \"'$message'\", \"as_user\": \"true\"}"
          #curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $token" "https://slack.com/api/chat.postMessage" -d '{"channel": "'$channel'", "text": "'"$message"'", "as_user": "true"}' #works
           ;;
        *)
          echo "this command does not exist, please look at the following:"
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
  echo "For Slack, you will need to join http://join.slack.ole.org/ and create a Slack app at https://api.slack.com/apps give it a name and add it to the Open Learning Exchange Worskspace, click on Permissions under adding a feature, go to Scopes, go to User Token Scopes, and click on 'Add an OAuth Scope', find the scope: 'chat:write' and add it, then install the app to the workspace by going to the top of OAuth and Permissions, and click 'Install App to Workspace', you will have to reinstall if you make any changes to the app, which will regenerate your OAuth token, on the OAuth exchange page you will be redirected to, check the permissions and click Allow, then copy the OAuth Access token to your clipboard and you can now use it here to send messages  "
  echo
  echo "Example:"
  echo
  echo "  $BASENAME message gitter apitoken"
  echo "     check for API token"
  echo 
  echo "  $BASENAME message gitter authorize \"1234567890\""
  echo "     sets and saves API token"
  echo
  echo "  $BASENAME message gitter send treehouses/Lobby \"Hi, you are very awesome\""
  echo "     Sends a message to a gitter channel"
  echo
  echo "  $BASENAME message gitter receive show treehouses/Lobby"
  echo "     Marks unread messages from a gitter channel to read"
  echo
  echo "  $BASENAME message gitter receive read treehouses/Lobby"
  echo "     Receives and displays unread messages from a gitter channel"
  echo
  echo "  $BASENAME message gitter receive mark treehouses/Lobby"
  echo "     Marks unread messages from a gitter channel to read"
  echo
  echo "  $BASENAME message slack apikey" 
  echo "     Sets and saves API token"
  echo
  echo "  $BASENAME message slack sendto \"C12345678\" \"Hi, you are very awesome\"" 
  echo "     Sends a message to a slack channel using channel id"
  echo
  echo "  $BASENAME message slack sendto \"channel_name\" \"Hi, you are very awesome\"" 
  echo "     Sends a message to a slack channel using channel name, eg, channel: #channel_name"
  echo
}
