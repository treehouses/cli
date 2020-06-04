function networkmode {
  local network_mode interfaces ifaces
  checkargn $# 1
  network_mode="default"
  if [ -f "/etc/network/mode" ]; then
    network_mode=$(</etc/network/mode)
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

  if iface_exists "usb0"; then
    if grep -q usb0 /var/lib/dhcp/*.leases && ip route get 8.8.8.8 | grep -q usb0; then
      if [ $network_mode == "default" ]; then
        echo default > /etc/network/last_mode
      fi
      network_mode="tether"
      interfaces+=("usb0")
    fi
  fi 

  if [ "$network_mode" == "tether" ] && ! ip link | grep -q usb0; then 
    mv /etc/network/last_mode /etc/network/mode
    network_mode=$(</etc/network/mode)
  fi 

  if [ "$1" == "info" ]; then
    checkroot
    if [ "$network_mode" == "wifi" ]; then
      get_wpa_supplicant_settings
    elif [ "$network_mode" == "bridge" ]; then
      echo "wlan0: $(get_wpa_supplicant_settings)"
      echo "ap0: $(get_hostapd_settings)"
    elif [[ "$network_mode" == *"ap local"* ]] || [[ "$network_mode" == *"ap internet"* ]]; then
      get_ap_settings "$network_mode"
    elif [ "$network_mode" == "static wifi" ]; then
      get_staticnetwork_info "wlan0"
    elif [ "$network_mode" == "static ethernet" ]; then
      get_staticnetwork_info "eth0"
    elif [ "$network_mode" == "tether" ]; then
      echo "network mode is tether."
      if iface_exists usb0; then
        echo "ip: $(/sbin/ip -o -4 addr list 'usb0' |
          awk '{print $4}' | sed '2d' | cut -d/ -f1)"
      fi
    elif [ "$network_mode" == "default" ]; then
      echo "network mode is default."
      ifaces=(eth0 wlan0)
      for interface in "${ifaces[@]}"
      do
        if [ ! -z "$(get_ipv4_ip "$interface")" ]; then
          echo "$interface ip: $(get_ipv4_ip "$interface")"
        fi
      done
    else
      for interface in "${interfaces[@]}"
      do
        if [ ! -z "$(get_ipv4_ip "$interface")" ]; then
          echo "$network_mode $interface ip: $(get_ipv4_ip "$interface")"
        fi
      done
    fi
  else
    if [ "$1" == "" ]; then	   
      echo "$network_mode"
    else
      networkmode_help
      exit 1
    fi
  fi
}

function get_ap_name {
  sed -n "s/.*ssid=\\(.*\\)/\\1/p" /etc/hostapd/hostapd.conf
}

function get_ap_settings {
  local iseth0
  if ! grep -q "wpa_passphrase=*" "/etc/hostapd/hostapd.conf"; then
    echo -n "wlan0: ap essid: $(get_ap_name), ap has no password, ip: $(get_ipv4_ip wlan0),"
  else
    echo -n "wlan0: ap essid: $(get_ap_name), ap has password, ip: $(get_ipv4_ip wlan0),"
  fi
  if [[ "$1" == *"ap local"* ]]; then
    echo " not sharing internet"
  else
    echo " sharing internet"
  fi
  iseth0=$(get_ipv4_ip eth0)
  if [ -z "$iseth0" ]; then
    echo "eth0: no uplink, maybe ethernet cable is unplugged?"
  else
    echo "eth0: ip: $iseth0"
  fi
}

function get_staticnetwork_info {
  local interface ip_address netmask gateway dns network_name
  interface="$1"
  ip_address=$(sed -n "s/.*address \\(.*\\)/\\1/p" "/etc/network/interfaces.d/$interface")
  netmask=$(sed -n "s/.*netmask \\(.*\\)/\\1/p" "/etc/network/interfaces.d/$interface")
  gateway=$(sed -n "s/.*gateway \\(.*\\)/\\1/p" "/etc/network/interfaces.d/$interface")
  dns=$(sed -n "s/.*dns-nameservers \\(.*\\)/\\1/p" "/etc/network/interfaces.d/$interface")
  echo -n "$interface: static, ip: $ip_address, netmask: $netmask, gateway: $gateway, dns: $dns"
  if [ "$interface" == "wlan0" ]; then
    network_name=$(sed -n "s/.*ssid=\"\\(.*\\)\"/\\1/p" /etc/wpa_supplicant/wpa_supplicant.conf)
    echo -n ", essid: $network_name, "
    if grep -q "key_mgmt=NONE" "/etc/wpa_supplicant/wpa_supplicant.conf"; then
      echo "has no password"
    else
      echo "has password"
    fi
  else
    echo
  fi
}

function get_wpa_supplicant_settings {
  local network_name network_ip
  network_name=$(sed -n "s/.*ssid=\"\\(.*\\)\"/\\1/p" /etc/wpa_supplicant/wpa_supplicant.conf)
  network_ip=$(get_ipv4_ip wlan0)
  echo -n "essid: $network_name, ip: $network_ip, "
  if grep -q "key_mgmt=NONE" "/etc/wpa_supplicant/wpa_supplicant.conf"; then
    echo "has no password"
  else
    echo "has password"
  fi
}

function get_hostapd_settings {
  local network_name network_ip
  network_name=$(get_ap_name)
  network_ip=$(get_ipv4_ip ap0)
  if ! grep -q "wpa_passphrase=*" "/etc/hostapd/hostapd.conf"; then
    echo "essid: $network_name, ip: $network_ip, has no password"
  else
    echo "essid: $network_name, ip: $network_ip, has password"
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
