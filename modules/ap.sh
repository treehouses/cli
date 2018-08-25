#!/bin/bash

function ap {
  mode=$1
  essid=$2
  password=$3
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
  cp "$TEMPLATES/network/eth0/default" /etc/network/interfaces.d/eth0
  cp "$TEMPLATES/network/dhcpcd/modular" /etc/dhcpcd.conf 
  cp "$TEMPLATES/network/dnsmasq/hotspot" /etc/dnsmasq.conf 
  cp "$TEMPLATES/network/hostapd/default" /etc/default/hostapd

  if [ "$mode" = "internet" ]; then
    cp "$TEMPLATES/network/wlan0/hotspot_shared" /etc/network/interfaces.d/wlan0
    cp "$TEMPLATES/network/eth0-shared.sh" /etc/network/eth0-shared.sh
  elif [ "$mode" = "local" ]; then
    cp "$TEMPLATES/network/wlan0/hotspot" /etc/network/interfaces.d/wlan0
  else
    echo "Error: only 'local' and 'internet' modes are supported".
    exit 0
  fi

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


function ap_help () {
  echo ""
  echo "Usage: treehouses ap <local|internet> <ESSID> [password]"
  echo ""
  echo "Creates a mobile ap. If the mode is 'internet' the ethernet connection will be shared in the ap."
  echo ""
  echo "Examples:"
  echo "  treehouses ap local apname apPassword"
  echo "      Creates a ap with ESSID 'apname' and password 'apPassword'."
  echo "      This hotspot will not share the ethernet connection if present."
  echo ""
  echo "  treehouses ap local apname"
  echo "      Creates an open ap with ESSID 'apname'."
  echo "      This hotspot will not share ethernet connection when present."
  echo ""
  echo "  treehouses ap internet apname apPassword"
  echo "      Creates a ap with ESSID 'apname' and password 'apPassword'."
  echo "      This hotspot will share the ethernet connection when present."
  echo ""
  echo "  treehouses ap internet apname"
  echo "      Creates an open ap with ESSID 'apname'."
  echo "      This hotspot will share the ethernet connection when present."
  echo ""
}