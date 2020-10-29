function shutdown {
  checkargn $# 2
  checkroot
  case "$1" in
    "")
      echo "Shutting down in 60 seconds. Press crtl+c to cancel"
      sleep 60
      /sbin/shutdown now
       ;;
    "now")
      /sbin/shutdown now
      ;;
    "in")
      echo "Shutting down in $2 seconds. Press crtl+c to cancel"
      sleep "$2"
      /sbin/shutdown now
      ;;
    "force")
      /sbin/shutdown -f
      ;;
    *)
       echo "Error: only now, in and force options are supported"
       ;;
  esac
}

function shutdown_help {
  echo
  echo "Usage: $BASENAME shutdown [now|in|force]"
  echo
  echo "Shuts down the system"
  echo
  echo "Example:"
  echo "  $BASENAME shutdown"
  echo "      System shutdown in 60 seconds. 'ctrl+c' to cancel"
  echo
  echo "  $BASENAME shutdown now"
  echo "      System shutdown immediately"
  echo
  echo "  $BASENAME shutdown in <time in seconds>"
  echo "      System will shutdown after the specified time. 'ctrl+c' to cancel"
  echo
  echo "  $BASENAME shutdown force"
  echo "      System will force shutdown"
  echo
}
