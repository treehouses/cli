function stream {
  checkargn $# 1
  case "$1" in
    "")
      stream on
    ;;

    "on")
      echo "Starting treehouse stream..."
      python3 modules/stream_treehouse.py > /dev/null 2>&1 &
      echo "Treehouse stream has started at 127.0.0.1:8000/index.html"
      echo "It can be stopped with treehouses stream off."
    ;;
    
    "off")
      echo "Stopping treehouse stream..."
      pkill -f stream_treehouse.py
      echo "Treehouse stream has ended." 
    ;;
    
    *)
       stream_help
    ;;
  esac
}

function stream_help {
  echo
  echo "  Usage: $BASENAME stream [on|off]"
  echo
  echo "  Example:"
  echo
  echo "    $BASENAME stream on"
  echo "      Starting treehouse stream..."
  echo "      Treehouse stream has started at 127.0.0.1:8000/index.html"
  echo "      It can be stopped with treehouses stream off."
  echo
  echo "    $BASENAME stream off"
  echo "      Stopping treehouse stream..."
  echo "      Treehouse stream has ended." 
  echo
}