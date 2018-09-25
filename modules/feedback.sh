#!/bin/bash

function feedback {
  message="$1"
  curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Bearer adfab56b2f10b85f94db25f18e51a4b465dbd670" "https://api.gitter.im/v1/rooms/<token>/chatMessages" -d "{\"text\":\"$(hostname) ($(curl ifconfig.io -s)) said:\n$message\"}" > /dev/null
  echo "Thanks for the feedback!"
}

function ssh_help {
  echo ""
  echo "Usage: $(basename "$0") feedback <message>"
  echo ""
  echo "Shares feedback with the developers"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") feedback \"Hi\""
  echo "      todo."
  echo ""
}
