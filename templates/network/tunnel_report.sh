#!/bin/bash

prevStatus=$(cat /tmp/prev_ssh_status 2>/dev/null || echo "offline")
if ping -q -c 3 -W 200 1.1.1.1 >/dev/null; then
  echo "rpi is online, was $prevStatus"
  if [ "$prevStatus" = "offline" ]; then
    echo "online" > /tmp/prev_ssh_status
    treehouses sshtunnel notice now
  fi
else
  echo "rpi is offline, was $prevStatus"
  echo "offline" > /tmp/prev_ssh_status
fi
