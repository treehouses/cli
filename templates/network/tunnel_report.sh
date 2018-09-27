#!/bin/bash

function report {
  port=$(grep -oP "(?<=\-M)(.*?) " /etc/tunnel)
  nmode=$(cat /etc/network/mode 2>/dev/null || echo "default")
  curl --data-urlencode "message=**$(hostname)** ($(curl ifconfig.io -s)) | port: **$port** | network: **$nmode** | rpi: **$(treehouses detectrpi)** | cli: **$(treehouses version)** | img: **$(cat /boot/version.txt)** | _**$(date "+%F %H:%M:%S UTC" -u)**_" https://webhooks.gitter.im/e/eb6bedd04ecb36255d0a
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
