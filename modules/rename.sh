#!/bin/bash

function rename () { 

  if
    [[ ${1:0:1} == "-" ]] || #checks beginning for "-"
    [[ ${1: -1} == "-" ]] || #checks end for "-"
    ! [[ "$1" =~ ^[[:alnum:]"-"]*$ ]] || #checks for special characters and spaces excluding "-"
    [[ ${#1} -gt "64" ]] || #Checks for length greater than 64
    [ -z "$1" ]; #Checks if variable is empty
  then
    echo "Unsuccessful: Make sure to remove special characters."  
  else
    CURRENT_HOSTNAME=$(< /etc/hostname tr -d " \\t\\n\\r")
    echo "$1" > /etc/hostname
    sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\\t$1/g" /etc/hosts
    hostname "$1"
    echo "Success: the hostname has been modified to $1"
  fi
}

function rename_help () {
  echo
  echo "Usage: $BASENAME rename <hostname>"
  echo
  echo "Changes the hostname"
  echo
  echo "Example:"
  echo "  $BASENAME rename rpi"
  echo "      Sets the hostname to 'rpi'."
  echo
}
