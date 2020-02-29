#!/bin/bash

function wifibridge {
  local wifinetwork wifipassword wificountry
  if [ -z "$1" ]; then
    echo "Error: name of the network missing"
    exit 1
  fi

  wifinetwork=$1
  wifipassword=$2

  if [ -n "$wifipassword" ]
  then
    if [ ${#wifipassword} -lt 8 ]
    then
      echo "Error: password must have at least 8 characters"
      exit 1
    fi
  fi

  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces
  cp "$TEMPLATES/network/wlan0/default" /etc/network/interfaces.d/wlan0
  cp "$TEMPLATES/network/eth0/default" /etc/network/interfaces.d/eth0
  cp "$TEMPLATES/network/dhcpcd/modular" /etc/dhcpcd.conf
  cp "$TEMPLATES/network/dnsmasq/default" /etc/dnsmasq.conf
  cp "$TEMPLATES/rc.local/default" /etc/rc.local

  cp "$TEMPLATES/network/10-wpa_supplicant" /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
  rm -rf /etc/udev/rules.d/90-wireless.rules

  {
    echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev"
    echo "update_config=1"
    wificountry="US"
    if [ -r /etc/rpi-wifi-country ];
    then
      wificountry=$(cat /etc/rpi-wifi-country)
    fi
    echo "country=$wificountry"
  } > /etc/wpa_supplicant/wpa_supplicant.conf

  if [ -z "$wifipassword" ];
  then
    {
      echo "network={"
      echo "  ssid=\"$wifinetwork\""
      echo "  key_mgmt=NONE"
      echo "}"
    } >> /etc/wpa_supplicant/wpa_supplicant.conf
    restart_wifi >"$LOGFILE" 2>"$LOGFILE"
    checkwifi
  else
    wpa_passphrase "$wifinetwork" "$wifipassword" >> /etc/wpa_supplicant/wpa_supplicant.conf
    restart_wifi >"$LOGFILE" 2>"$LOGFILE"
    checkwifi
  fi

  ip_address="192.168.2.1"
  netmask="255.255.255.0"

  sudo systemctl start network-online.target &> /dev/null

  sudo iptables -F
  sudo iptables -t nat -F
  sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
  sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
  sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

  sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

  sudo ifconfig eth0 $ip_address netmask $netmask

  # Remove default route created by dhcpcd
  sudo ip route del 0/0 dev eth0 &> /dev/null

  sudo systemctl stop dnsmasq

  sudo rm -rf /etc/dnsmasq.d/* &> /dev/null

  cp "$TEMPLATES/network/wifibridge" /etc/dnsmasq.d/custom-dnsmasq.conf

  sudo systemctl start dnsmasq

  echo "wifibridge" > /etc/network/mode
}

function checkwifi {
  if iwconfig wlan0 | grep -q "ESSID:off/any"; then
    echo "Wifi is not connected."
    echo ""
    echo "Check you SSID and password and retry."
    echo ""
    exit 1
  fi
}

function wifibridge_help {
  echo ""
  echo "Lets users connect to wifi network and build bridge to ethernet"
  echo ""
  echo "Usage:"
  echo ""
  echo "$BASENAME wifibridge <wifi_name> [Password]"
  echo "  Connects raspberry pi to SSID and bridges the wifi connection"
  echo "  to the pi's ethernet port"
  echo ""
}
