#! /bin/bash 

checkroot 
checkrpi

ip link set usb0 up 
dhclient usb0 2>/dev/null

echo "tether" > /etc/network/mode
