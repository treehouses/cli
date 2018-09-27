#!/bin/bash

token="adfab56b2f10b85f94db25f18e51a4b465dbd670"
#\`$(treehouses detectrpi)\`
function feedback {
  message="$*"
  curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer $token" "https://api.gitter.im/v1/rooms/5ba5af3cd73408ce4fa8fcfb/chatMessages" -d "{\"text\":\"\`$(hostname)\` \`$(curl ifconfig.io -s)\` \`$(treehouses version)\` \`RPI3B+\` \`$(cat /boot/version.txt)\`:\n$message\"}" > /dev/null
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
