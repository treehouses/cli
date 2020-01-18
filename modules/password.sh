#!/bin/bash

function disable_pass {
  passwd -l $1 && echo -e "Sucess: password login of  user $1 is locked, system is only accessed via ssh" 
}

function password () {
  if [[ -z "$1" ]];then
    disable_pass "$(whoami)"
  else 
    echo "pi:$1" | chpasswd
    echo "Success: the password has been changed"
  fi 
}

function password_help () {
  echo ""
  echo "Usage: $(basename "$0") password <password>"
  echo ""
  echo "Changes the password for 'pi' user. If the password is left empty, the password is disabled during ssh login session"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") "
  echo "      disable password login"
  echo "  $(basename "$0") password ABC"
  echo "      Sets the password for 'pi' user to 'ABC'."
  echo ""
}
