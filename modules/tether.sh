#! /bin/bash 

checkroot 
checkrpi

ip link set usb0 up 
dhclient usb0

echo "tether" > /etc/network/mode
