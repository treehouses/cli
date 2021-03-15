function message {
  chats="$1"
  function check_apitoken {
    channelname=$1_apitoken
    access_token=$(config | grep "$channelname" | cut -d "=" -f2)
    if [[ $access_token == "" ]] || [[ $access_token == "null" ]]; then
      return 1
    else
      return 0
    fi
  }
  function get_apitoken {
    channelname=$1_apitoken
    access_token=$(config | grep "$channelname" | grep "token" | cut -d "=" -f2)
    echo "Your API access token is $access_token"
    return 0
  }
  function get_channel_gitter {
    channel_info=$(curl -s -H "Accept: application/json" -H "Authorization: Bearer $access_token" "https://api.gitter.im/v1/rooms")
    channel_names=$(echo $channel_info | python -m json.tool | jq '.[].name' | tr -d '"')
    echo "$channel_names"
  }
  function get_channel_slack {
    if channel_list=$(curl -s -F token=$access_token -F types=public_channel,private_channel https://slack.com/api/users.conversations); then
      channel_list=$(curl -s -F token=$access_token -F types=public_channel,private_channel https://slack.com/api/users.conversations)
    else
      echo "Error: Failed to use some permissions"
      echo "Go to api.slack.com/apps, then click 'OAuth & Permissions' under 'Features' to check if the above permissions have been added."
      exit 1
    fi

    if channels=$(echo $channel_list | python -m json.tool | jq '.channels[].name' | tr -d '"'); then
      channels=$(echo $channel_list | python -m json.tool | jq '.channels[].name' | tr -d '"')
    else
      echo "Error: Failed to use some permissions"
      echo "Go to api.slack.com/apps, then click 'OAuth & Permissions' under 'Features' to check if the above permissions have been added."
      exit 1
    fi

    if user_list=$(curl -s -F token=$access_token https://slack.com/api/users.list); then
      user_list=$(curl -s -F token=$access_token https://slack.com/api/users.list)
    else
      echo "Error: Failed to use some permissions"
      echo "Go to api.slack.com/apps, then click 'OAuth & Permissions' under 'Features' to check if the above permissions have been added."
      exit 1
    fi

    if users=$(echo $user_list | python -m json.tool | jq '.members[].name' | tr -d '"'); then
      users=$(echo $user_list | python -m json.tool | jq '.members[].name' | tr -d '"')
    else
      echo "Error: Failed to use some permissions"
      echo "Go to api.slack.com/apps, then click 'OAuth & Permissions' under 'Features' to check if the above permissions have been added."
      exit 1
    fi

    if channel_names=$(echo -e "$channels\n$users"); then
      channel_names=$(echo -e "$channels\n$users")
    else
      echo "Error: Failed to use some permissions"
      echo "Go to api.slack.com/apps, then click 'OAuth & Permissions' under 'Features' to check if the above permissions have been added."
      exit 1
    fi

    echo "$channel_names"
  }
  function check_group {
    group=$1
    group_names=($(get_channel_gitter))
    for i in "${group_names[@]}"; do
      if [[ $i == "$group" ]]; then
        return 0
        break
      fi
    done
    return 1
  }
  case "$chats" in
    gitter)
      case "$2" in
        apitoken)
          if check_apitoken gitter; then
            get_apitoken gitter
          elif [[ $3 != "" ]] && [[ $4 != "" ]]; then
            client_id=$3
            if [[ $4 == http?(s)://* ]]; then
              redirect_uri=$4
            else
              log_and_exit1 "Invalid URL"
            fi
            conf_var_update "gitter_clientid" "$client_id"
            conf_var_update "gitter_redirecturl" "$redirect_uri"
            echo "Navigate to  https://gitter.im/login/oauth/authorize?client_id=$client_id&response_type=code&redirect_uri=$redirect_uri"
            echo "Click 'Allow' and get the code at the end of the redirect link:"
            echo "Example:redirect link: http://www.localhost.com/?code=1234567890, code=1234567890"
            echo "run $BASENAME message gitter authorize <code> <0auth Secret>"
          else
            echo "You do not have an authorized access token"
            echo ""
            echo "To get an authorized access token"
            echo "Navigate to https://developer.gitter.im/apps and signin"
            echo "Create a new app and provide aplication name and a redirect url where you will be send after authorization"
            echo "After creating your app, you will be provided a oauth key, a oauth secret and the redirect URL"
            echo "Run $BASENAME message gitter apitoken <oauth key> <redirect url>"
            echo "Click 'Allow' and get the code at the end of the redirect link:"
            echo "Example: If redirect link is \"http://www.localhost.com/?code=1234567890\",then \"code=1234567890\""
            echo "Run $BASENAME message gitter authorize <code> <oauth Secret>"
          fi
          ;;
        authorize)
          if [[ $3 == "" ]]; then
            echo "authorization code is missing"
          elif [[ $4 == "" ]]; then
             echo "oauth secret is missing"
          else
            code=$3
            client_key=$4
            conf_var_update "gitter_clientkey" "$client_key"
            client_id=$(config | grep "$gitter_clientid" | cut -d "=" -f2)
            redirect_uri=$(config | grep "$gitter_redirecturl" | cut -d "=" -f2)
            api_info=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" "https://gitter.im/login/oauth/token" -d '{"client_id": "'$client_id'", "client_secret": "'$client_key'", "code": "'$code'", "redirect_uri": "'$redirect_uri'", "grant_type": "authorization_code"}')
            token_info=$(echo $api_info | python -m json.tool | jq '.access_token' | tr -d '"')
            conf_var_update "gitter_apitoken" "$token_info"
            echo "Your API access token is $token_info"
          fi
          ;;
        channels)
          if check_apitoken gitter; then
            channels_names=$(get_channel_gitter)
            echo "Channel Names:"
            echo "$channels_names"
          else
            log_comment_and_exit1 "Error: You do not have an authorized access token" "To get access token, run $BASENAME message gitter apitoken"
          fi
          ;;
        send)
          group=$3
          if check_apitoken gitter; then
            if [[ $3 == "" ]]; then
              log_comment_and_exit1 "ERROR: Group information is missing" "usage: $BASENAME message gitter send <group>"
            elif ! check_group $group; then
              log_and_exit1 "You are not part of this group"
            else
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
                log_and_exit1 "No message was submitted."
              fi
            fi
          else
            log_comment_and_exit1 "Error:You do not have an authorized access token" "To get access token, run $BASENAME message gitter apitoken"
          fi
          ;;
        show)
          group=$3
          if check_apitoken gitter; then
            if [[ $group == "" ]]; then
              log_comment_and_exit1 "ERROR: Group information is missing" "usage: $BASENAME message gitter send <group>"
            elif ! check_group $group; then
              log_and_exit1 "You are not part of this group"
            else
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
            fi
          else
            log_comment_and_exit1 "Error: You do not have an authorized access token" "To get access token, run $BASENAME message gitter apitoken"
          fi
          ;;
        read)
          group="$3"
          if check_apitoken gitter; then
            if [[ $group == "" ]]; then
              log_comment_and_exit1 "ERROR: Group information is missing" "usage: $BASENAME message gitter send <group>"
            elif ! check_group $group; then
              log_and_exit1 "You are not part of this group"
            else
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
            fi
          else
            log_comment_and_exit1 "Error: You do not have an authorized access token" "To get access token, run $BASENAME message gitter apitoken"
          fi
          ;;
        mark)
          group="$3"
          if check_apitoken gitter; then
            if [[ $group == "" ]]; then
              log_comment_and_exit1 "ERROR: Group information is missing" "usage: $BASENAME message gitter send <group>"
            elif ! check_group $group; then
              log_and_exit1 "You are not part of this group"
            else
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
            fi
          else
            log_comment_and_exit1 "Error: You do not have an authorized access token" "To get access token, run $BASENAME message gitter apitoken"
          fi
          ;;
        *)
          log_help_and_exit1 "Error: This command does not exist" message
          ;;
      esac
      ;;
    slack)
      function check_channel {
        channel_list=$(curl -s -F token=$access_token https://slack.com/api/conversations.list)
        channel_list=($(echo $channel_list | python -m json.tool | jq '.channels[].id' | tr -d '"'))
        for i in "${channel_list[@]}"; do
          if [ $i == $1 ]; then
            return 0
            break
          fi
        done
        return 1
      }
      function get_channel_id {
      name="$1"
      count=0
      conversation_list=$(curl -s -F token=$access_token https://slack.com/api/conversations.list)
      channel_name=($(echo $conversation_list | python -m json.tool | jq '.channels[].name' | tr -d '"'))
      for i in "${channel_name[@]}"; do
        if [[ $name == "$i" ]]; then
          channel_id=$(echo $conversation_list | python -m json.tool | jq '.channels['$count'].id' | tr -d '"')
          echo $channel_id
          break
        fi
        ((count=count+1))
      done
      }
      case "$2" in
        apitoken)
          if [[ $3 != "" ]]; then
            tempVar=$(echo $3 | cut -d "-" -f 1)
            if [[ $tempVar != "xoxp" ]]; then
              log_comment_and_exit1 "invalid token"
            else
              conf_var_update "slack_apitoken" "$3"
              echo "your apitoken is $3"
            fi
          elif check_apitoken slack; then
            get_apitoken slack
          else
            echo "To get an authorized access token"
            echo ""
            echo "Navigate to https://api.slack.com/apps and create an APP. Provide a name for the APP and select the \"Development Slack Workspace (eg : Open Learning Exchange)\" from the drop down list"
            echo "Go to \"OAuth & Permission\" under \"features \" and select the scope under \"User Token Scopes\" and add \"chat:write\", \"channels:write\", \"channel:read\", \"channel:history\", \"groups:write\", \"group:read\", \"mpim:write\", \"im:write\", \"usergroups.read\" and \"users.read\" for the APP from the drop down list"
            echo "Then install APP to the workspace and click the allow button to give permissions in the redirected link and then you will get the \"OAuth access token\""
            echo "Run $BASENAME message slack apitoken <oauth access token>"
          fi
          ;;
        channels)
          if check_apitoken slack; then
            channel_names=$(get_channel_slack)
            echo "Channels Names:"
            echo
            echo "$channel_names"
          else
            log_comment_and_exit1 "Error: You do not have an authorized access token" "To get access token, run $BASENAME message slack apitoken"
          fi
          ;;
        send)
          channel=$3
          if check_apitoken slack; then
            if [[ $channel == "" ]]; then
              log_comment_and_exit1 "ERROR: Channel information is missing" "usage: $BASENAME message slack send <group>"
            elif [[ "${channel:0:1}" == [a-z] ]]; then
              channel=$(get_channel_id $3)
            fi
            shift; shift; shift;
            message=$*
            message_response=$(curl -s -X POST -H 'Authorization: Bearer '$access_token'' -H 'Content-type: application/json' --data "{\"channel\":\"$channel\",\"text\":\"$message\"}" https://slack.com/api/chat.postMessage)
            message_response=$(echo $message_response | python -m json.tool | jq '.ok' | tr -d '"')
            if [[ $message_response == "true" ]]; then
              echo "message successfully delivered to $channel"
            else
              log_comment_and_exit1 "ERROR: message not delivered"
            fi
          else
            log_comment_and_exit1 "Error:You do not have an authorized access token" "To get access token, run $BASENAME message slack apitoken"
          fi
          ;;
        show)
          channel=$3
          if check_apitoken slack; then
            if [[ $channel == "" ]]; then
              log_comment_and_exit1 "ERROR: Channel information is missing" "usage: $BASENAME message slack read <group>"
            elif [[ "${channel:0:1}" == [a-z] ]]; then
              channel=$(get_channel_id $3)
            fi
            if ! check_channel $channel; then
              log_and_exit1 "invalid channel ID or channel name"
            else
              channel_info=$(curl -s -F token=$access_token -F channel=$channel https://slack.com/api/conversations.info)
              last_read=$(echo $channel_info | python -m json.tool | jq '.channel.last_read' | tr -d '"')
              channel_history=$(curl -s -F token=$access_token -F channel=$channel https://slack.com/api/conversations.history)
              time=($(echo $channel_history | python -m json.tool | jq '.messages[].ts' 2> /dev/null | tr -d '"'))
              unread_time=()
              for i in "${time[@]}"; do
                if [ $last_read == $i ]; then
                  break
                else
                  unread_time+=($i)
                fi
              done
              unread_time=($(printf '%s\n' "${unread_time[@]}" | tac | tr '\n' ' '))
              if [ ${#unread_time[@]} -eq 0 ]; then
                echo "You have no unread messages at the moment"
              else
                for i in "${unread_time[@]}"; do
                  msg_info=$(curl -s -F token=$access_token -F channel=$channel -F latest=$i -F limit=1 -F inclusive=true https://slack.com/api/conversations.history)
                  msg=$(echo $msg_info | python -m json.tool | jq '.messages[].text' | tr -d '"')
                  userid=$(echo $msg_info | python -m json.tool | jq '.messages[].user' | tr -d '"')
                  name_info=$(curl -s -F token=$access_token -F user=$userid -F latest=$i https://slack.com/api/users.info)
                  name=$(echo $name_info | python -m json.tool | jq '.user.profile.real_name' | tr -d '"')
                  time_info=$(date -d @$i)
                  date=$(echo ${time_info} | cut -d " " -f1-3)
                  year=$(echo ${time_info} | cut -d " " -f6)
                  send_time=$(echo ${time_info} | cut -d " " -f4)
                  echo "Date: $date $year"
                  echo "Time: $send_time"
                  echo "From: $name"
                  echo "Message: $msg"
                done
              fi
            fi
          fi
          ;;
        read)
          channel=$3
          if check_apitoken slack; then
            if [[ $channel == "" ]]; then
              log_comment_and_exit1 "ERROR: Channel information is missing" "usage: $BASENAME message slack read <group>"
            elif [[ "${channel:0:1}" == [a-z] ]]; then
              channel=$(get_channel_id $3)
            fi
            if ! check_channel $channel; then
              log_and_exit1 "invalid channel ID or channel name"
            else
              channel_info=$(curl -s -F token=$access_token -F channel=$channel https://slack.com/api/conversations.info)
              last_read=$(echo $channel_info | python -m json.tool | jq '.channel.last_read' | tr -d '"')
              channel_history=$(curl -s -F token=$access_token -F channel=$channel https://slack.com/api/conversations.history)
              time=($(echo $channel_history | python -m json.tool | jq '.messages[].ts' 2> /dev/null | tr -d '"'))
              unread_time=()
              for i in "${time[@]}"; do
                if [ $last_read == $i ]; then
                  break
                else
                  unread_time+=($i)
                fi
              done
              unread_time=($(printf '%s\n' "${unread_time[@]}" | tac | tr '\n' ' '))
              if [ ${#unread_time[@]} -eq 0 ]; then
                echo "You have no unread messages at the moment"
              else
                for i in "${unread_time[@]}"; do
                  msg_info=$(curl -s -F token=$access_token -F channel=$channel -F latest=$i -F limit=1 -F inclusive=true https://slack.com/api/conversations.history)
                  curl -s -F token=$access_token -F channel=$channel -F ts=$i https://slack.com/api/conversations.mark > "$LOGFILE"
                  msg=$(echo $msg_info | python -m json.tool | jq '.messages[].text' | tr -d '"')
                  userid=$(echo $msg_info | python -m json.tool | jq '.messages[].user' | tr -d '"')
                  name_info=$(curl -s -F token=$access_token -F user=$userid -F latest=$i https://slack.com/api/users.info)
                  name=$(echo $name_info | python -m json.tool | jq '.user.profile.real_name' | tr -d '"')
                  curl -s -F token=$access_token -F channel=$channel -F ts=$i https://slack.com/api/conversations.mark > "$LOGFILE"
                  time_info=$(date -d @$i)
                  date=$(echo ${time_info} | cut -d " " -f1-3)
                  year=$(echo ${time_info} | cut -d " " -f6)
                  send_time=$(echo ${time_info} | cut -d " " -f4)
                  echo "Date: $date $year"
                  echo "Time: $send_time"
                  echo "From: $name"
                  echo "Message: $msg"
                done
              fi
            fi
          fi
          ;;
        mark)
          channel=$3
          if check_apitoken slack; then
            if [[ $channel == "" ]]; then
              log_comment_and_exit1 "ERROR: Channel information is missing" "usage: $BASENAME message slack read <group>"
            elif [[ "${channel:0:1}" == [a-z] ]]; then
              channel=$(get_channel_id $3)
            fi
            if ! check_channel $channel; then
              log_and_exit1 "invalid channel ID or channel name"
            else
              channel_info=$(curl -s -F token=$access_token -F channel=$channel https://slack.com/api/conversations.info)
              last_read=$(echo $channel_info | python -m json.tool | jq '.channel.last_read' | tr -d '"')
              channel_history=$(curl -s -F token=$access_token -F channel=$channel https://slack.com/api/conversations.history)
              time=($(echo $channel_history | python -m json.tool | jq '.messages[].ts' 2> /dev/null | tr -d '"'))
              unread_time=()
              for i in "${time[@]}"; do
                if [ $last_read == $i ]; then
                  break
                else
                  unread_time+=($i)
                fi
              done
              unread_time=($(printf '%s\n' "${unread_time[@]}" | tac | tr '\n' ' '))
              if [ ${#unread_time[@]} -eq 0 ]; then
                echo "You have no unread messages at the moment"
              else
                for i in "${unread_time[@]}"; do
                  curl -s -F token=$access_token -F channel=$channel -F ts=$i https://slack.com/api/conversations.mark > "$LOGFILE"
                done
                echo "Done. Messages marked as read "
              fi
            fi
          fi
          ;;
        *)
          log_help_and_exit1 "Error: This command does not exist" message
      esac
      ;;
    discord)
      case "$2" in
        apitoken)
          if check_apitoken discord; then
            get_apitoken discord
          elif [[ $3 != "" ]] && [[ $4 != "" ]]; then
            client_id=$3
            if [[ $4 == http?(s)://* ]]; then
              redirect_uri=$4
            else
              log_and_exit1 "Invalid URL"
            fi
            conf_var_update "discord_clientid" "$client_id"
            conf_var_update "discord_redirecturl" "$redirect_uri"
            authorization_url=$(curl -Ls -o /dev/null -w %'{'url_effective'}' https://discord.com/api/oauth2/authorize?response_type=token\&client_id=${client_id}\&scope=identify)
            echo "To get the access token, navigate to"
            echo
            echo "$authorization_url"
            echo
            echo "Then, click \"Authorize\" to provide permissions for your app"
            echo "From the redirected link , you will get your access token for discord"
            echo
            echo "For example, if redirected link is \"http://localhost/token_type=Bearer&access_token=1234567890&expires_in=604800&scope=identify\"' then the access token is \"1234567890\""
            echo "Then, run $BASENAME message discord authorize <access_token>"
          else
            echo "You do not have an authorized access token"
            echo ""
            echo "To get an authorized access token"
            echo ""
            echo "Navigate to https://discord.com/developers/applications. Create an APP by clicking \"New Application\" and provide a suitable name for your APP."
            echo "Then move to the option \"OAuth2\" below \"General Information\" and add a redirect URL ( For eg: http://localhost/ ) by clicking \"Add Redirect\" below \"Redirects\"."
            echo "Then, save the settings by pressing green save button at the bottom of the page."
            echo "Note both the CLIENT ID and your Redirect URL"
            echo "Run $BASENAME message discord apitoken <client_id> <redirect_url>"
          fi
            ;;
        authorize)
          if [[ $3 == "" ]]; then
            echo "authorization code is missing"
          else
          access_token=$3
            conf_var_update "discord_apitoken" "$access_token"
            echo "you have successfully authorized and your access token is $access_token "
          fi
          ;;
        *)
          log_help_and_exit1 "Error: This command does not exist" message
      esac
      ;;
    *)
      log_help_and_exit1 "Error: This command does not exist" message
      ;;
  esac
}

function message_help {
  echo
  echo "Usage: $BASENAME message <chats>" 
  echo "                    <apitoken>"
  echo "                    <oauth key> <redirect URL>"
  echo "                    <authorize> <code> <oauth secret>"
  echo "                    <send> <group> <message>"
  echo "                    <show|read|mark> <group>"
  echo
  echo "You can get your token from:"
  echo "https://developer.gitter.im/docs/welcome"
  echo "by signing in."
  echo
  echo "It should show up immediately or by navigating to:"
  echo "https://developer.gitter.im/apps"
  echo
  echo "You must set your api key at least once every session"
  echo "before sending a message"
  echo
  echo "Send message to a chat service"
  echo
  echo "Example:"
  echo
  echo "  $BASENAME message gitter apitoken"
  echo "     Check for API token for gitter"
  echo
  echo "  $BASENAME message gitter authorize \"1234567890\""
  echo "     Sets and saves API token"
  echo
  echo "  $BASENAME message gitter channels"
  echo "     check for channels"
  echo
  echo "  $BASENAME message gitter send treehouses/Lobby \"Hi, you are very awesome\""
  echo "     Sends a message to a gitter channel"
  echo
  echo "  $BASENAME message gitter show treehouses/Lobby"
  echo "     Marks unread messages from a gitter channel to read"
  echo
  echo "  $BASENAME message gitter read treehouses/Lobby"
  echo "     Receives and displays unread messages from a gitter channel"
  echo
  echo "  $BASENAME message gitter mark treehouses/Lobby"
  echo "     Marks unread messages from a gitter channel to read"
  echo
  echo "  $BASENAME message slack apitoken"
  echo "     check for API token for slack"
  echo
  echo "  $BASENAME message slack channels"
  echo "     check for channels"
  echo
  echo "  $BASENAME message slack send \"channel name or ID\" \"Hello!\""
  echo "     Sends a message to a slack channel using channel ID/name"
  echo
  echo "  $BASENAME message slack show \"channel ID\""
  echo "     Shows messages of a slack channel using channel ID"
  echo
  echo "  $BASENAME message slack read \"channel ID\""
  echo "     Reads messages from a slack channel using channelID"
  echo
  echo "  $BASENAME message slack mark \"channel ID\""
  echo "     Marks messages of a slack channel using channel ID"
  echo
  echo "  $BASENAME message discord apitoken"
  echo "     Check for API token for discord"
  echo
  echo "  $BASENAME message discord authorize \"1234567890\""
  echo "     Sets and saves API token"
  echo
}
