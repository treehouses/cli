#!/bin/bash

function hotspot {
  essid=$1
  password=$2
  channels=(1 6 11)
  channel=${channels[$((RANDOM % ${#channels[@]}))]};

  if [ -n "$password" ];
  then
    if [ ${#password} -lt 8 ];
    then
      echo "Error: password must have at least 8 characters"
      exit 1
    fi
  fi

  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces 
  cp "$TEMPLATES/network/wlan0/hotspot" /etc/network/interfaces.d/wlan0
  cp "$TEMPLATES/network/eth0/default" /etc/network/interfaces.d/eth0
  cp "$TEMPLATES/network/dhcpcd/modular" /etc/dhcpcd.conf 
  cp "$TEMPLATES/network/dnsmasq/hotspot" /etc/dnsmasq.conf 
  cp "$TEMPLATES/network/hostapd/default" /etc/default/hostapd
  cp "$TEMPLATES/rc.local/hotspot" /etc/rc.local

  cp "$TEMPLATES/network/10-wpa_supplicant" /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
  rm -rf /etc/udev/rules.d/90-wireless.rules

  if [ -n "$password" ];
  then
    cp "$TEMPLATES/network/hostapd/password" /etc/hostapd/hostapd.conf
    sed -i "s/ESSID/$essid/g" /etc/hostapd/hostapd.conf
    sed -i "s/PASSWORD/$password/g" /etc/hostapd/hostapd.conf
    sed -i "s/CHANNEL/$channel/g" /etc/hostapd/hostapd.conf
    restart_hotspot >/dev/null 2>/dev/null
  else 
    cp "$TEMPLATES/network/hostapd/no_password" /etc/hostapd/hostapd.conf
    sed -i "s/ESSID/$essid/g" /etc/hostapd/hostapd.conf
    sed -i "s/CHANNEL/$channel/g" /etc/hostapd/hostapd.conf
    restart_hotspot >/dev/null 2>/dev/null
  fi

  echo "This pirateship has anchored successfully!"
}

function hotspot_help () {
  echo ""
  echo "Usage: treehouses hotspot <ESSID> [password]"
  echo ""
  echo "Creates a mobile hotspot"
  echo ""
  echo "Examples:"
  echo "  treehouses hotspot hotspotname hotspotpassword"
  echo "      Creates a hotspot with ESSID 'hotspotname' and password 'hotspotpassword'."
  echo ""
  echo "  treehouses hotspot hotspotname"
  echo "      Creates an open hotspot with ESSID 'hotspotname'."
  echo ""
}