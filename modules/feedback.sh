#!/bin/bash

token="adfab56b2f10b85f94db25f18e51a4b465dbd670"

function feedback {
  message="$*"
  if [ "$(detectrpi)" != "nonrpi" ]; then
    body="{\"text\":\"\`$(hostname)\` \`$(curl ifconfig.io -s)\` \`$(version)\` \`$(detectrpi)\` \`$(cat /boot/version.txt)\`:\\n$message\"}"
  else
    body="{\"text\":\"\`$(hostname)\` \`$(curl ifconfig.io -s)\` \`$(version)\` \`$(detect | sed "s/ /\` \`/1")\`:\\n$message\"}"
  fi

  curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $token" "https://api.gitter.im/v1/rooms/5ba5af3cd73408ce4fa8fcfb/chatMessages" -d  "$body"> /dev/null
  echo "Thanks for the feedback!"
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
