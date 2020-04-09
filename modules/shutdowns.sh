function shutdowns {
  checkargn $# 2
  checkroot
  case "$1" in
    "")
      echo "shutting down now. Press ctrl+c to cancel "
      sleep 5
      shutdown now
      ;;
    "now")
      shutdown now
      ;;
    "in")
       echo "shutting down in "$2" seconds. Press crtl+c to cancel"
       sleep "$2"
       shutdown now
       ;;
     "-f") 
      echo "shutting down now. Press ctrl+c to cancel "
      sleep 5
      shutdown -f now
      ;;
    *)
       echo "Error: only now, in and -f commands works"
     ;;       
esac
}


function shutdowns_help {
  echo
  echo "  Usage: $BASENAME shutdown <now|in|-f>"
  echo
  echo "  Shutdown the system"
  echo
  echo "  Example:"
  echo "  $BASENAME shutdown"
  echo "  System will shutdown within five seconds. ctrl+c to cancel"
  echo
  echo "  $BASENAME shutdown now"
  echo "  System will shutdown immediately"
  echo 
  echo " $BASENAME shutdown in <time in seconds>"
  echo " System will shutdown after the specified time. ctrl+c to cancel"
  echo 
  echo " $BASENAME shutdown -f"
  echo " System will force shutdown"
  echo
}



