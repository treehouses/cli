#!/bin/bash

function networkmode {
  network_mode="default"
  if [ -f "/etc/network/mode" ]; then
    network_mode=$(cat "/etc/network/mode")
  fi

  interfaces=()
  case $(detectrpi) in
    RPI3B|RPI3B+|RPI2B|RPI4B)
      # this rpis have eth0 and wlan0 by default.
      if iface_exists "eth1"; then
        network_mode="external"
        interfaces+=("eth1")
      fi

      if iface_exists "wlan1"; then
        network_mode="external"
        interfaces+=("wlan1")
      fi
    ;;
    RPIZW|RPI3A+)
      # this rpis only have wlan0 by default.
      if iface_exists "eth0"; then
        network_mode="external"
        interfaces+=("eth0")
      fi
      if iface_exists "wlan1"; then
        network_mode="external"
        interfaces+=("wlan1")
      fi
    ;;
  esac

  if [ "$1" == "info" ]; then
    if [ "$network_mode" == "wifi" ]; then
      checkroot
      get_wpa_supplicant_settings
    elif [ "$network_mode" == "bridge" ]; then
      checkroot
      logit "wlan0: $(get_wpa_supplicant_settings)"
      logit "ap0: $(get_hostapd_settings)"
    elif [ "$network_mode" == "ap local" ] || [ "$network_mode" == "ap internet" ]; then
      get_ap_settings "$network_mode"
    elif [ "$network_mode" == "static wifi" ]; then
      get_staticnetwork_info "wlan0"
    elif [ "$network_mode" == "static ethernet" ]; then
      get_staticnetwork_info "eth0"
    elif [ "$network_mode" == "default" ]; then
      logit "network mode is default."
      ifaces=(eth0 wlan0)
      for interface in "${ifaces[@]}"
      do
        if [ ! -z "$(get_ipv4_ip "$interface")" ]; then
          logit "$interface ip: $(get_ipv4_ip "$interface")"
        fi
      done
    else
      for interface in "${interfaces[@]}"
      do
        if [ ! -z "$(get_ipv4_ip "$interface")" ]; then
          logit "$network_mode $interface ip: $(get_ipv4_ip "$interface")"
        fi
      done
    fi
  else
    logit "$network_mode"
  fi
}

function get_ap_name {
  sed -n "s/.*ssid=\\(.*\\)/\\1/p" /etc/hostapd/hostapd.conf
}

function get_ap_settings {
  if ! grep -q "wpa_passphrase=*" "/etc/hostapd/hostapd.conf"; then
    logit "wlan0: ap essid: $(get_ap_name), ap has no password, ip: $(get_ipv4_ip wlan0)," "" "" "2"
  else
    logit "wlan0: ap essid: $(get_ap_name), ap has password, ip: $(get_ipv4_ip wlan0)," "" "" "2"
  fi
  if [ "$1" == "ap local" ]; then
    logit " not sharing internet"
  else
    logit " sharing internet"
  fi
  iseth0=$(get_ipv4_ip eth0)
  if [ -z "$iseth0" ]; then
    logit "eth0: no uplink, maybe ethernet cable is unplugged?"
  else
    logit "eth0: ip: $iseth0"
  fi
}

function get_staticnetwork_info {
  interface="$1"
  ip_address=$(sed -n "s/.*address \\(.*\\)/\\1/p" "/etc/network/interfaces.d/$interface")
  netmask=$(sed -n "s/.*netmask \\(.*\\)/\\1/p" "/etc/network/interfaces.d/$interface")
  gateway=$(sed -n "s/.*gateway \\(.*\\)/\\1/p" "/etc/network/interfaces.d/$interface")
  dns=$(sed -n "s/.*dns-nameservers \\(.*\\)/\\1/p" "/etc/network/interfaces.d/$interface")
  logit "$interface: static, ip: $ip_address, netmask: $netmask, gateway: $gateway, dns: $dns" "" "" "2"
  if [ "$interface" == "wlan0" ]; then 
    network_name=$(sed -n "s/.*ssid=\"\\(.*\\)\"/\\1/p" /etc/wpa_supplicant/wpa_supplicant.conf)
    logit ", essid: $network_name, " "" "" "2"
    if grep -q "key_mgmt=NONE" "/etc/wpa_supplicant/wpa_supplicant.conf"; then
      logit "has no password"
    else
      logit "has password"
    fi
  else
    echo
  fi
}

function get_wpa_supplicant_settings {
  network_name=$(sed -n "s/.*ssid=\"\\(.*\\)\"/\\1/p" /etc/wpa_supplicant/wpa_supplicant.conf)
  network_ip=$(get_ipv4_ip wlan0)
  logit "essid: $network_name, ip: $network_ip, "  "" "" "2"
  if grep -q "key_mgmt=NONE" "/etc/wpa_supplicant/wpa_supplicant.conf"; then
    logit "has no password"
  else
    logit "has password"
  fi
}

function get_hostapd_settings {
  network_name=$(get_ap_name)
  network_ip=$(get_ipv4_ip ap0)
  if ! grep -q "wpa_passphrase=*" "/etc/hostapd/hostapd.conf"; then
    logit "essid: $network_name, ip: $network_ip, has no password"
  else
    logit "essid: $network_name, ip: $network_ip, has password"
  fi
}

function networkmode_help {
  echo
  echo "Usage: $BASENAME networkmode [info]"
  echo
  echo "Outputs the current network mode"
  echo
  echo "Example:"
  echo "  $BASENAME networkmode"
  echo "      Will output the current network mode that has been set up using $BASENAME"
  echo
  echo "  $BASENAME networkmode info"
  echo "      shows the current status of the network mode"
  echo
}
