#!/bin/bash

prevStatus=$(cat /tmp/prev_openvpn_status 2>/dev/null || echo "offline")
if ping -I tun0 -q -c 3 -W 1 1.1.1.1 >/dev/null; then
  echo "vpn is online, was $prevStatus"
  if [ "$prevStatus" = "offline" ]; then
    echo "online" > /tmp/prev_openvpn_status
    treehouses openvpn notice now
  fi
else
  echo "vpn is offline, was $prevStatus"
  echo "offline" > /tmp/prev_openvpn_status
fi
