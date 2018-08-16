#!/bin/bash
# https://raspberrypi.stackexchange.com/questions/71348/cannot-forward-from-wlan-interface-to-another-wlan-interface
AP_INTERFACE="ap0" # ap
SOURCE_INTERFACE="wlan0" # to router

# Flush rules
iptables -t nat -F
iptables -F

# Apply new rules
iptables -t nat -A POSTROUTING -o $SOURCE_INTERFACE -j MASQUERADE
iptables -A FORWARD -i $SOURCE_INTERFACE -o $AP_INTERFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $AP_INTERFACE -j ACCEPT

while /bin/true;
do
  while ! ifconfig wlan0 2>/dev/null | grep "inet " -q;
  do
      sleep 1
      echo "Waiting for wlan0 to have an ip."
  done
  echo "Ok. wlan0 has an ip"

  ips=$(ip r | sed -n '/default .* wlan0 .* metric .*/p' | head -n1 | sed -n 's/metric .*/metric 1/p')
  ip r add $ips
  break
done &
