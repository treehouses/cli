#!/bin/bash

function staticwifi {
  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces
  cp "$TEMPLATES/network/wlan0/static" /etc/network/interfaces.d/wlan0

  cp "$TEMPLATES/network/10-wpa_supplicant" /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
  rm -rf /etc/udev/rules.d/90-wireless.rules

  sed -i "s/IPADDRESS/$1/g" /etc/network/interfaces.d/wlan0
  sed -i "s/NETMASK/$2/g" /etc/network/interfaces.d/wlan0
  sed -i "s/GATEWAY/$3/g" /etc/network/interfaces.d/wlan0
  sed -i "s/DNS/$4/g" /etc/network/interfaces.d/wlan0

  essid="$5"
  password="$6"

  if [ -n "$password" ];
  then
    if [ ${#password} -lt 8 ];
    then
      echo "Error: password must have at least 8 characters"
      exit 1
    fi
  fi

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

  if [ -z "$password" ];
  then
    {
      echo "network={"
      echo "  ssid=\"$essid\""
      echo "  key_mgmt=NONE"
      echo "}"
    } >> /etc/wpa_supplicant/wpa_supplicant.conf
  else
    wpa_passphrase "$essid" "$password" >> /etc/wpa_supplicant/wpa_supplicant.conf
  fi

  restart_wifi >"$LOGFILE" 2>"$LOGFILE"

  echo "static wifi" > /etc/network/mode

  reboot_needed
  echo "Success: the wifi settings have been changed, a reboot is required in order to see the changes"
}

function staticwifi_help {
  echo
  echo "Usage: $BASENAME staticwifi <ip> <mask> <gateway> <dns> <ESSID> [password]"
  echo
  echo "Configures wifi interface (wlan0) to use a static ip address"
  echo
  echo "Examples:"
  echo "  $BASENAME staticwifi 192.168.1.101 255.255.255.0 192.168.1.1 9.9.9.9 home homewifipassword"
  echo "      Connects to wifi named 'home' with password 'homewifipassword' and sets the wifi interface IP address to 192.160.1.1, mask 255.255.255.0, gateway 192.168.1.1, DNS 9.9.9.9"
  echo
  echo "  $BASENAME staticwifi 192.168.1.101 255.255.255.0 192.168.1.1 9.9.9.9 home"
  echo "      Connects to an open wifi named 'home' and sets the wifi interface IP address to 192.160.1.1, mask 255.255.255.0, gateway 192.168.1.1, DNS 9.9.9.9"
  echo
}