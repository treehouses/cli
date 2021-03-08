function password {
  checkrpi
  checkroot
  checkargn $# 2
  options="$1"
  case "$options" in
  "change")
    case "$password" in
      "")
        log_and_exit1 "Error: Password not entered"
        ;;
      *)
        chpasswd <<< "pi:$password"
        echo "Success: the password has been changed"
        ;;
    esac
    ;;
  "disable")
    disablepassword
    ;;
  "enable")
    enablepassword
    ;;
  *)
    log_and_exit1 "Error: Must use an option 'change', 'disable', or 'enable'"
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
  echo "Usage: $BASENAME password change <password>"
  echo "       $BASENAME password [disable|enable]"
  echo
  echo "Changes the password for 'pi' user"
  echo
  echo "Example:"
  echo "  $BASENAME change password ABC"
  echo "      Sets the password for 'pi' user to 'ABC'."
  echo
  echo "  $BASENAME password disable"
  echo "      Disables password authentication (only passphrase allowed)"
  echo
  echo "  $BASENAME password enable"
  echo "      Enables password authentication (password or passphrase allowed)"
}
