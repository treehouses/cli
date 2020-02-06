#!/bin/bash

function bridge {
  case $(detectrpi) in
    RPI3B|RPIZW|RPI3B+|RPI3A+|RPI4B)
      ;;
    *)
      echo "Your rpi model is not supported"
      exit 1;
  esac

  wifiessid=$(clean_var "$1")
  hotspotessid=$(clean_var "$2")
  wifipassword=$(clean_var "$3")
  hotspotpassword=$(clean_var "$4")
  base_24=$(echo "${@: -1}" | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}' | awk '{sub(/.$/,""); gsub("--ip=","", $0); print}')
  channels=(1 6 11)
  channel=${channels[$((RANDOM % ${#channels[@]}))]};

  if [ -z "$hotspotessid" ];
  then
    echo "a hotspot essid is required"
    exit 1
  fi

  if [ -n "$hotspotessid" ]
  then
    if [ ${#hotspotessid} -gt 32 ]
    then
      echo "Error: hotspot essid must be no greater than 32 characters"
      exit 1
    fi
  fi

  if [ -n "$wifipassword" ];
  then
    if [ ${#wifipassword} -lt 8 ];
    then
      echo "Error: wifi password must have at least 8 characters"
      exit 1
    fi
  fi

  if [ -n "$hotspotpassword" ];
  then
    if [ ${#hotspotpassword} -lt 8 ];
    then
      echo "Error: hotspot password must have at least 8 characters"
      exit 1
    fi
  fi

  cp "$TEMPLATES/network/dnsmasq/bridge" "/etc/dnsmasq.conf"
  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces 
  cp "$TEMPLATES/network/wlan0/bridge" /etc/network/interfaces.d/ap0

  if [ -z "$hotspotpassword" ];
  then
    cp "$TEMPLATES/network/hostapd/bridge_no_password" /etc/hostapd/hostapd.conf
  else
    cp "$TEMPLATES/network/hostapd/bridge_password" /etc/hostapd/hostapd.conf
    sed -i "s/PASSWORD/$hotspotpassword/g" /etc/hostapd/hostapd.conf
  fi

  cp "$TEMPLATES/network/hostapd/default" /etc/default/hostapd
  sed -i "s/CHANNEL/$channel/g" /etc/hostapd/hostapd.conf
  sed -i "s/ESSID/$hotspotessid/g" /etc/hostapd/hostapd.conf

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
        echo "  ssid=\"$wifiessid\""
        echo "  key_mgmt=NONE"
        echo "}"
    } >> /etc/wpa_supplicant/wpa_supplicant.conf
  else
    {
      echo "network={"
      echo "  ssid=\"$wifiessid\""
      echo "  psk=\"$wifipassword\""
      echo "}"
    } >> /etc/wpa_supplicant/wpa_supplicant.conf
  fi

  enable_service hostapd
  enable_service dnsmasq
  cp "$TEMPLATES/network/90-wireless.rules" /etc/udev/rules.d/90-wireless.rules
  rm -rf /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
  cp "$TEMPLATES/network/10-wpa_supplicant_bridge" /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
  cp "$TEMPLATES/rc.local/bridge" /etc/rc.local
  cp "$TEMPLATES/network/up-bridge.sh" /etc/network/up-bridge.sh

  if [ -n "$base_24" ];
  then
    sed -i "s/BASE_24/$base_24/g" /etc/dnsmasq.conf
    sed -i "s/BASE_24/$base_24/g" /etc/network/interfaces.d/ap0
  else
    sed -i "s/BASE_24/192.168.2/g" /etc/dnsmasq.conf
    sed -i "s/BASE_24/192.168.2/g" /etc/network/interfaces.d/ap0
  fi

  echo "bridge" > /etc/network/mode

  sync; sync; sync
  reboot_needed
  echo "the bridge has been built ;), a reboot is required to apply changes"
}

function bridge_help {
  echo
  echo "Usage: $BASENAME bridge <WifiESSID> <HotspotESSID> [WifiPassword] [HotspotPassword]"
  echo
  echo "Bridges the wlan0 interface to ap0, creating a hotspot with desired configuration."
  echo
  echo "Examples:"
  echo "  $BASENAME bridge MyWifi MyHotspot"
  echo "      This will connect to 'MyWifi' which is an open essid, and create an open hotspot called 'MyHotspot'"
  echo
  echo "  $BASENAME bridge MyWifi MyHotspot 12345678"
  echo "      This will connect to 'MyWifi' which has a password '12345678', and create an open hotspot called 'MyHotspot'"
  echo
  echo "  $BASENAME bridge MyWifi MyHotspot 12345678 hotspot123"
  echo "      This will connect to 'MyWifi' which has a password '12345678', and create a password hotspot called 'MyHotspot' with the password 'hotspot123'"
  echo
  echo "  $BASENAME bridge MyWifi MyHotspot \"\" 12345678"
  echo "      This will connect to 'MyWifi' which is an open essid, and create a password hotspot called 'MyHotspot' with the password '12345678'"
  echo
  echo "  This command can be used with the argument '--ip=x.y.z.w' to specify the base ip (x.y.z) for the clients/ap."
  echo
  echo "  $BASENAME bridge MyWifi MyHotspot \"\" 12345678 --ip=192.168.2.2"
  echo "      All the clients of this network will have an ip under the network 192.168.2.0"
  echo
}
