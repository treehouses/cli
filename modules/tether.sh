#! /bin/bash 

function tethermain {
  checkroot 
  checkrpi

  if [ -z "$(ip link | grep usb0)" ]; then 
    echo 
    echo "USB interface not found."
    echo "Please check your connection and/or if usb tethering is enabled in your phone setting"
    echo 
    exit 1
  fi 

  ip link set usb0 up 
  dhclient usb0 2>/dev/null
  systemctl is-active --quiet dhcpcd || systemctl enable --now --quiet dhcpcd
  echo "tether" > /etc/network/mode
  echo "USB tethering successfully enabled."
}

function tether {
  tethermain
}

function tether_help {
  echo
  echo "Usage: $BASENAME tether"
  echo
}
