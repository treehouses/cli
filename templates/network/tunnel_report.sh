#!/bin/bash

tunnelno="$1"
if [ -z "$tunnelno" ];
then
  tunnelno=0
fi
prevStatus=$(cat /tmp/prev_ssh_status$tunnelno || echo "offline")
if ping -q -c 3 -W 1 1.1.1.1 >/dev/null; then
  echo "rpi is online, was $prevStatus"
  if [ "$prevStatus" = "offline" ]; then
    echo "online" > /tmp/prev_ssh_status$tunnelno
    treehouses sshtunnel notice now $tunnelno
  fi
else
  echo "rpi is offline, was $prevStatus"
  echo "offline" > /tmp/prev_ssh_status$tunnelno
fi
