function password {
  checkrpi
  checkroot
  checkargn $# 1
  if [[ $1 == "" ]]; then
    log_and_exit1 "Error: Password not entered"
  elif [ $1 == "disable" ]; then
    disablepassword 
  else
    chpasswd <<< "pi:$1"
    echo "Success: the password has been changed"
  fi
}

function disablepassword {
  if grep -Fxq "PasswordAuthentication no" /etc/ssh/sshd_config 
  then
    log_an_exit1 "Password authentication is already disabled"
  else
    sed -i "s/^#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
    echo "Successfully disabled password authentication"
  fi
}

function password_help {
  echo
  echo "Usage: $BASENAME password <password>"
  echo
  echo "Changes the password for 'pi' user"
  echo
  echo "Example:"
  echo "  $BASENAME password ABC"
  echo "      Sets the password for 'pi' user to 'ABC'."
  echo
}
