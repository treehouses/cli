#!/bin/bash

token="adfab56b2f10b85f94db25f18e51a4b465dbd670"
channel="https://api.gitter.im/v1/rooms/5ba5af3cd73408ce4fa8fcfb/chatMessages"
# set on ../templates/network/tor_report.sh
if [ ! -z "$gitter_channel" ]; then
  channel="$gitter_channel"
fi

function feedback {
  message="$*"
  ip6_regex="^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:))$"
  ip4_regex="((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])"
  if ! [[ -z "$message" ]]; then
    ip_address=$(curl ifconfig.io -s)
    if [[ ! $ip_address =~ $ip6_regex ]] && [[ ! $ip_address =~ $ip4_regex ]]; then
      ip_address="invalid address"
    fi
    if [ "$(detectrpi)" != "nonrpi" ]; then
      body="{\"text\":\"\`$(hostname)\` \`$ip_address\` \`$(version)\` \`$(detectrpi)\` \`$(cat /boot/version.txt)  \`:\\n$message\"}"
    else
      body="{\"text\":\"\`$(hostname)\` \`$ip_address\` \`$(version)\` \`$(detect | sed "s/ /\` \`/1")\`:\\n$message\"}"
    fi
    curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $token"   "$channel" -d  "$body"> "$LOGFILE"
    echo "Thanks for the feedback!"
  else
    echo "No feedback was submitted."
  fi
}

function feedback_help {
  echo
  echo "Usage: $BASENAME feedback <message>"
  echo
  echo "Shares feedback with the developers"
  echo
  echo "Example:"
  echo "  $BASENAME feedback \"Hi, you are very awesome\""
  echo "      Gives some feedback that the developers will read :)"
  echo
}
