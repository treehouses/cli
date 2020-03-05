#!/bin/bash

disable_pass () 
{
  passwd -l "$1" && echo "Sucess: password login of  user $1 is locked, system is only accessed via ssh" || echo "Error: Password can't be disable"
}

enable_pass ()
{
  passwd -u "$1" && echo "Sucess: password is unlocked."
}

password () 
{
  local current_user="$(whoami)"
  case "$1" in
  '', -l, --lock)
    disable_pass "$current_user"
    ;;
  -u, --unlock)
    enable_pass "$current_user" 
    ;;
  *)
    echo "pi:$1" | chpasswd
    echo "Success: the password has been changed"
    ;;
  esac
}

password_help () 
{
  echo ""
  echo "Usage: $(basename "$0") password <-l|-u> <password>"
  echo ""
  echo "Changes the password for 'pi' user. If the password is left empty, the password is disabled during ssh login session"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") "
  echo "      disable password login"
  echo "  $(basename "$") -l"
  echo "      disable password login
  echo "  $(basename "$") -u"
  echo "      enable password login
  echo "  $(basename "$0") password ABC"
  echo "      Sets the password for 'pi' user to 'ABC'."
  echo ""
}
