function password {
  checkrpi
  checkroot
  checkargn $# 1

  case "$1" in
  "")
    log_and_exit1 "Error: Password not entered"
    ;;
  "disable")
    disablepassword
    ;;
  "enable")
    enablepassword
    ;;
  *)
    chpasswd <<< "pi:$1"
    echo "Success: the password has been changed"
    ;;
  esac
}

function disablepassword {
  checkroot
  passwd -l pi
  echo "Password disabled successfully"
}

function enablepassword {
  checkroot
  passwd -u pi
  echo "Password enabled successfully"
}

function password_help () {
  echo
  echo "Usage: $BASENAME password <password>"
  echo "       $BASENAME password [disable|enable]"
  echo
  echo "Changes the password for 'pi' user"
  echo
  echo "Example:"
  echo "  $BASENAME password ABC"
  echo "      Sets the password for 'pi' user to 'ABC'."
  echo
  echo "  $BASENAME password disable"
  echo "      Disables password authentication (only passphrase allowed)"
  echo
  echo "  $BASENAME password enable"
  echo "      Enables password authentication (password or passphrase allowed)"
}
