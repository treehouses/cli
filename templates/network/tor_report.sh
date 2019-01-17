#!/bin/bash

function report {
  treehouses feedback "$(treehouses tor)"
  echo "report"
}


prevStatus=$(cat /tmp/prev_tor_status 2>/dev/null || echo "offline")
if ping -q -c 3 -W 1 1.1.1.1 >/dev/null; then
  echo "rpi is online, was $prevStatus"
  if [ "$prevStatus" = "offline" ]; then
    echo "online" > /tmp/prev_tor_status
    report
  fi
else
  echo "rpi is offline, was $prevStatus"
  echo "offline" > /tmp/prev_tor_status
fi