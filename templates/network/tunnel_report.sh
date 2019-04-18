#!/bin/bash

function report {
  portinterval=$(grep -oP "(?<=\-M)(.*?) " /etc/tunnel)
  portssh=$((portinterval + 22))
  portweb=$((portinterval + 80))
  portcouchdb=$((portinterval + 84))
  portnewcouchdb=$((portinterval + 82))
  portmunin=$((portinterval + 49))
  while read -r channel; do
    export gitter_channel="$channel"
    treehouses feedback "$(sed -r "s/.* (.*?)$/\1/g" /etc/tunnel | tail -n1):$portinterval\n$portssh:22 $portweb:80 $portnewcouchdb:2200 $portmunin:4949 $portcouchdb:5984\n\`$(date -u +"%Y-%m-%d %H:%M:%S %Z")\` $(treehouses networkmode)"
  done < /etc/tunnel_report_channels.txt
  echo "report"
}


prevStatus=$(cat /tmp/prev_ssh_status 2>/dev/null || echo "offline")
if ping -q -c 3 -W 1 1.1.1.1 >/dev/null; then
  echo "rpi is online, was $prevStatus"
  if [ "$prevStatus" = "offline" ]; then
    echo "online" > /tmp/prev_ssh_status
    report
  fi
else
  echo "rpi is offline, was $prevStatus"
  echo "offline" > /tmp/prev_ssh_status
fi
