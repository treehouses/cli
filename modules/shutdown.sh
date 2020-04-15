function shutdown {
  checkargn $# 2
  checkroot
  case "$1" in
    "")
      /sbin/shutdown
       ;;
    "now")
      /sbin/shutdown now 
      ;;
    "in")
      echo "Shutting down in $2 seconds. Press crtl+c to cancel"
      sleep "$2"
      /sbin/shutdown now
      ;;
    "-f") 
      /sbin/shutdown -f
      ;;
    *)
       echo "Error: only now, in and -f commands works"
       ;;       
  esac
} 

function shutdown_help {
  echo
  echo "  Usage: $BASENAME shutdown <now|in|-f>"
  echo
  echo "  Shutdowns system"
  echo
  echo "  Example:"
  echo "  $BASENAME shutdown"
  echo "  System shutdowns in 60 seconds. shutdown -c to cancel"
  echo
  echo "  $BASENAME shutdown now"
  echo "  System shutdowns immediately"
  echo 
  echo " $BASENAME shutdown in <time in seconds>"
  echo " System will shutdown after the specified time. ctrl+c to cancel"
  echo 
  echo " $BASENAME shutdown -f"
  echo " System will force shutdown"
  echo
}



