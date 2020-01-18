#!/bin/bash

function ap {
  mode=$(clean_var "$1")
  essid=$(clean_var "$2")
  password=$(clean_var "$3")
  base_24=$(echo "${@: -1}" | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}' | awk '{sub(/.$/,""); gsub("--ip=","", $0); print}')
  channels=(1 6 11)
  channel=${channels[$((RANDOM % ${#channels[@]}))]};
  
  if [ -n "$essid" ]
  then
    if [ ${#essid} -gt 32 ]
    then
      echo "Error: essid must be no greater than 32 characters"
      exit 1
    fi
  fi
  
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

    echo "ap internet" > /etc/network/mode
  elif [ "$mode" = "local" ]; then
    cp "$TEMPLATES/network/wlan0/hotspot" /etc/network/interfaces.d/wlan0

    echo "ap local" > /etc/network/mode
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
    restart_hotspot >"$LOGFILE" 2>"$LOGFILE"
  else 
    cp "$TEMPLATES/network/hostapd/no_password" /etc/hostapd/hostapd.conf
    sed -i "s/ESSID/$essid/g" /etc/hostapd/hostapd.conf
    sed -i "s/CHANNEL/$channel/g" /etc/hostapd/hostapd.conf
    restart_hotspot >"$LOGFILE" 2>"$LOGFILE"
  fi

  if [ -n "$base_24" ];
  then
    sed -i "s/BASE_24/$base_24/g" /etc/dnsmasq.conf
    sed -i "s/BASE_24/$base_24/g" /etc/network/interfaces.d/wlan0
  else
    sed -i "s/BASE_24/192.168.2/g" /etc/dnsmasq.conf
    sed -i "s/BASE_24/192.168.2/g" /etc/network/interfaces.d/wlan0
  fi

  echo "This pirateship has anchored successfully!"
}


function ap_help () {
  echo
  echo "Usage: treehouses ap <local|internet> <ESSID> [password]"
  echo
  echo "Creates a mobile ap. If the mode is 'internet' the ethernet connection will be shared in the ap."
  echo
  echo "Examples:"
  echo "  treehouses ap local apname apPassword"
  echo "      Creates a ap with ESSID 'apname' and password 'apPassword'."
  echo "      This hotspot will not share the ethernet connection if present."
  echo
  echo "  treehouses ap local apname"
  echo "      Creates an open ap with ESSID 'apname'."
  echo "      This hotspot will not share ethernet connection when present."
  echo
  echo "  treehouses ap internet apname apPassword"
  echo "      Creates a ap with ESSID 'apname' and password 'apPassword'."
  echo "      This hotspot will share the ethernet connection when present."
  echo
  echo "  treehouses ap internet apname"
  echo "      Creates an open ap with ESSID 'apname'."
  echo "      This hotspot will share the ethernet connection when present."
  echo
  echo "  This command can be used with the argument '--ip=x.y.z.w' to specify the base ip (x.y.z) for the clients/ap."
  echo
  echo "  treehouses ap internet apname --ip=192.168.2.24"
  echo "      All the clients of this network will have an ip under the network 192.168.2.0"
  echo
}
