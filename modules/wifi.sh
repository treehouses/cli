#!/bin/bash

function wifi {

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
    echo "connected to open wifi network"
  else
    wpa_passphrase "$wifinetwork" "$wifipassword" >> /etc/wpa_supplicant/wpa_supplicant.conf
    restart_wifi >"$LOGFILE" 2>"$LOGFILE"
    checkwifi
    echo "connected to password network"
  fi

  echo "wifi" > /etc/network/mode
}

function wifi_help {
  echo
  echo "Usage: $BASENAME wifi <ESSID> [password]"
  echo
  echo "Connects to a wifi network"
  echo
  echo "Example:"
  echo "  $BASENAME wifi home homewifipassword"
  echo "      Connects to a wifi network named 'home' with password 'homewifipassword'."
  echo
  echo "  $BASENAME wifi yourwifiname"
  echo "      Connects to an open wifi network named 'yourwifiname'."
  echo
}
