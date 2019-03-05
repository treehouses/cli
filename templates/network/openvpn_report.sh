#!/bin/bash

function report {
  while read -r channel; do
    export gitter_channel="$channel"
    treehouses feedback "$(treehouses openvpn | tail -n 1 | tr "\n" "#" | sed 's/#/\\n/g')vpn"
  done < /etc/openvpn_report_channels.txt
  echo "report"
}



prevStatus=$(cat /tmp/prev_openvpn_status 2>/dev/null || echo "offline")
if ping -I tun0 -q -c 3 -W 1 1.1.1.1 >/dev/null; then
  echo "vpn is online, was $prevStatus"
  if [ "$prevStatus" = "offline" ]; then
    echo "online" > /tmp/prev_openvpn_status
    report
  fi
else
  echo "vpn is offline, was $prevStatus"
  echo "offline" > /tmp/prev_openvpn_status
fi
