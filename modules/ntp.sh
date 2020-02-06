#!/bin/bash

function ntp {
  status="$1"

  if [ "$status" = "internet" ]; then
    rm -rf /boot/time &> "$LOGFILE"
    sed -i "s/server 127\.127\.1\.0//" /etc/ntp.conf
    sed -i "s/fudge 127\.127\.1\.0 stratum 10//" /etc/ntp.conf
    sed -i "s/restrict 192\.168\.0\.0 mask 255\.255\.0\.0 nomodify notrap//" /etc/ntp.conf

    reboot_needed
    echo "Success: please reboot you rpi to apply changes."
  elif [ "$status" = "local" ]; then
    service ntp restart
    date > /boot/time
    hwclock -w
    hwclock -r >> /boot/time
    hwclock -s
    date >> /boot/time
    {
      echo "server 127.127.1.0"
      echo "fudge 127.127.1.0 stratum 10"
      echo "restrict 192.168.0.0 mask 255.255.0.0 nomodify notrap"
    } >> /etc/ntp.conf

    reboot_needed
    echo "Success: please reboot you rpi to apply changes."
  else
    echo "Error: only on, off options are supported"
    exit 0
  fi
}

function ntp_help {
  echo
  echo "Usage: $BASENAME ntp <local|internet>"
  echo
  echo "Enables or disables time through ntp servers"
  echo
  echo "Example:"
  echo "  $BASENAME ntp internet"
  echo "    Configures treehouses as a client with timing sourced from the internet"
  echo
  echo "  $BASENAME ntp local"
  echo "    Configures treehouses as a server with timing sourced from the onboard clock"
  echo
}
