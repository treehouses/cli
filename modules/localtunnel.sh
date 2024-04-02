function localtunnel {
  # check if localtunnel exists
  check_missing_binary lt

  case "$1" in
    "")
      localtunnel_help
    ;;
    
    *)
      lt -h "https://serverless.social" -p "$1"
    ;;
  esac
}

function localtunnel_help {
  echo
  echo "Usage: $BASENAME localtunnel [port number] "
  echo
  echo "  exposes a local port to outside world"
  echo
  echo "Example:"
	echo
  echo "  \`$BASENAME localtunnel 3000\`"
	echo 
  echo "  your url is: https://pink-catfish-46.serverless.social "
  echo
}
