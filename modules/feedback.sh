#!/bin/bash

token="adfab56b2f10b85f94db25f18e51a4b465dbd670"
channel="https://api.gitter.im/v1/rooms/5ba5af3cd73408ce4fa8fcfb/chatMessages"
# set on ../templates/network/tor_report.sh
if [ ! -z "$gitter_channel" ]; then
  channel="$gitter_channel"
fi

function feedback {
  ip_4="ip4 "
  ip_6="ip6 "
  ip_address=$(curl ifconfig.io -s)
  if [[ $ip_address == *"DOCTYPE"* ]]; then
	  echo "ifconfig.io is down, please execute 'treehouses feedback' later"  
  else
    if [[ $ip_address == *":"* ]]; then
      ip_address="${ip_6}${ip_address}"
    else
      ip_address="${ip_4}${ip_address}"
    fi
    
    message="$*"
    if ! [[ -z "$message" ]]; then
      if [ "$(detectrpi)" != "nonrpi" ]; then
        body="{\"text\":\"\`$(hostname)\` \`$ip_address\` \`$(version)\` \`$(detectrpi)\` \`$(cat /boot/version.txt)  \`:\\n$message\"}"
      else
        body="{\"text\":\"\`$(hostname)\` \`$ip_address\` \`$(version)\` \`$(detect | sed "s/ /\` \`/1")\`:\\n$message\"}"
      fi
      curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $token"   "$channel" -d  "$body"> /dev/null
      echo "Thanks for the feedback!"
    else
       echo "No feedback was submitted."
    fi
  fi
}

function feedback_help {
  echo ""
  echo "Usage: $(basename "$0") feedback <message>"
  echo ""
  echo "Shares feedback with the developers"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") feedback \"Hi, you are very awesome\""
  echo "      Gives some feedback that the developers will read :)"
  echo ""
}
