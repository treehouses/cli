#!/bin/bash

function networkmode {
  network_mode="default"
  if [ -f "/etc/network/mode" ]; then
    network_mode=$(cat "/etc/network/mode")
  fi

  if [ "$1" == "info" ]; then
    checkroot;

    if [ "$network_mode" == "wifi" ]; then
      get_wpa_supplicant_settings
    elif [ "$network_mode" == "bridge" ]; then
      echo "wlan0: $(get_wpa_supplicant_settings)"
      echo "ap0: $(get_hostapd_settings)"
    else [ "$network_mode" == "default" ]; then
      echo "network mode is default."
    fi
  else
    echo "$network_mode"
  fi
}

function get_wpa_supplicant_settings {
  network_name=$(sed -n "s/.*ssid=\"\(.*\)\"/\1/p" /etc/wpa_supplicant/wpa_supplicant.conf)
  network_ip=$(get_ipv4_ip wlan0)
  if grep -q "key_mgmt=NONE" "/etc/wpa_supplicant/wpa_supplicant.conf"; then
    echo "essid: $network_name, ip: $network_ip, has no password"
  else
    echo "essid: $network_name, ip: $network_ip, has password"
  fi
}

function get_hostapd_settings {
  network_name=$(sed -n "s/.*ssid=\(.*\)/\1/p" /etc/hostapd/hostapd.conf)
  network_ip=$(get_ipv4_ip ap0)
  if ! grep -q "wpa_passphrase=*" "/etc/hostapd/hostapd.conf"; then
    echo "essid: $network_name, ip: $network_ip, has no password"
  else
    echo "essid: $network_name, ip: $network_ip, has password"
  fi
}

function networkmode_help {
  echo ""
  echo "Usage: $(basename "$0") networkmode [info]"
  echo ""
  echo "Outputs the current network mode"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") networkmode"
  echo "      Will output the current network mode that has been set up using $(basename "$0")"
  echo ""
  echo "  $(basename "$0") networkmode info"
  echo "      shows the current status of the network mode"
  echo ""
}