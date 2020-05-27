#! /bin/bash 

function tethermain {
  checkroot 
  checkrpi

  if ! ip link | grep -q usb0; then 
    echo "USB interface not found"
    echo "Please check your connection"
    echo "Please check if USB tethering is enabled in your phone setting"
    exit 1
  fi 

  ip link set usb0 up 
  dhclient usb0 2>/dev/null
  systemctl is-active --quiet dhcpcd || systemctl enable --now --quiet dhcpcd
  if [ -f /etc/network/mode ]; then
    mv /etc/network/mode /etc/network/last_mode
  else 
    echo "default" > /etc/network/mode
  fi
  echo "tether" > /etc/network/mode
  echo "USB tethering enabled successfully."
}

function tether {
  tethermain
}

function tether_help {
  echo
  echo "Usage: $BASENAME tether"
  echo
}
