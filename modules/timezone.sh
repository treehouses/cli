#!/bin/bash

function timezone {
  timezone="$1"
  if [ -z "$timezone" ];
  then
    echo "Error: the timezone is missing"
    exit 1;
  fi

  if [ ! -f "/usr/share/zoneinfo/$timezone" ];
  then
    echo "Error: the timezone is not supported"
    exit 1;
  fi

  rm /etc/localtime
  echo "$timezone" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata 2>"$LOGFILE"
  echo "Success: the timezone has been set"
}

function timezone_help {
  echo
  echo "Usage: $BASENAME timezone <timezone>"
  echo
  echo "Sets the system timezone"
  echo
  echo "Example:"
  echo "  $BASENAME timezone Etc/GMT-3"
  echo "      This will set the raspberry pi time to GMT-3"
  echo "      When using Etc/GMT you can specify the offset, from GMT-14 up to GMT+12"
  echo "      Available timezones are inside /usr/share/zoneinfo/"
  echo
}