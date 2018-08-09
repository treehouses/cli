#!/bin/bash

function password () {
  echo "pi:$1" | chpasswd
  echo "Success: the password has been changed"
}

function password_help () {
  echo ""
  echo "Usage: $(basename "$0") password <password>"
  echo ""
  echo "Changes the password for 'pi' user"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") password ABC"
  echo "      Sets the password for 'pi' user to 'ABC'."
  echo ""
}