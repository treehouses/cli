function feedback {
  local message ip6_regex ip4_regex ip_address body
  message="$*"
  ip6_regex="^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:))$"
  ip4_regex="((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])"
  if ! [[ -z "$message" ]]; then
    ip_address=$(curl ifconfig.io -s)
    if [[ ! $ip_address =~ $ip6_regex ]] && [[ ! $ip_address =~ $ip4_regex ]]; then
      ip_address="invalid address"
    fi
    message="${message//\`/}"
    message="${message// /\\b}"
    if [ "$(detectrpi)" != "nonrpi" ]; then
      body="{\"content\":\"**$(hostname)**\b$ip_address\b$(version)\b$(detectrpi)\b$(cat /boot/version.txt)\n$message\"}"
    else
      body="{\"content\":\"**$(hostname)**\b$ip_address\b$(version)\b$(detect | sed "s/ /\\\b/1")\n$message\"}"
    fi
    curl -s -X POST -H "Content-Type:application/json" "$channel$token" -d $body> "$LOGFILE"
    echo "Thanks for the feedback!"
  else
    log_and_exit1 "No feedback was submitted."
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
