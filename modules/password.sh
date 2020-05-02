function password {
  checkrpi
  checkroot
  checkargn $# 1
  if [[ $1 == "" ]]; then
    log_and_exit1 "Error: Password not entered"
  elif [ $1 == "disable" ]; then
    disablepassword 
  elif [ $1 == "enable" ]; then
    enablepassword
  else
    chpasswd <<< "pi:$1"
    echo "Success: the password has been changed"
  fi
}

function disablepassword {
  if grep -Fxq "#PasswordAuthentication yes" /etc/ssh/sshd_config || grep -Fxq "#PasswordAuthentication no" /etc/ssh/sshd_config
  then
    sed -i "s/^#PasswordAuthentication /PasswordAuthentication no/" /etc/ssh/sshd_config 
    echo "Successfully disabled password authentication" 
  elif grep -Fxq "PasswordAuthentication no" /etc/ssh/sshd_config 
  then
    log_and_exit1 "Password authentication is already disabled"
  else
    sed -i "s/^PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
    echo "Successfully disabled password authentication"
  fi
}

function enablepassword {
  if grep -Fxq "#PasswordAuthentication yes" /etc/ssh/sshd_config || grep -Fxq "#PasswordAuthentication no" /etc/ssh/sshd_config
  then
    sed -i "s/^#PasswordAuthentication /PasswordAuthentication yes/" /etc/ssh/sshd_config
    echo "Successfully enabled password authentication"
  elif grep -Fxq "PasswordAuthentication yes" /etc/ssh/sshd_config 
  then
    log_and_exit1 "Password authentication is already enabled"
  else
    sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
    echo "Successfully enabled password authentication"
  fi
}
function password_help {
  echo
  echo "Usage: $BASENAME password <password>"
  echo "       $BASENAME password [disable|enable]"
  echo
  echo "Changes the password for 'pi' user"
  echo
  echo "Example:"
  echo "  $BASENAME password ABC"
  echo "      Sets the password for 'pi' user to 'ABC'."
  echo "  $BASENAME password disable"
  echo "      Disables password authentication (only passphrase allowed)"
  echo "  $BASENAME password enable"
  echo "      Enables password authentiaction (password or passphrase allowed)"
}
