#!/bin/bash

function bridge {
  case $(detectrpi) in
    RPI3B|RPIZW|RPI3B+)
      ;;
    *)
      echo "Your rpi model is not supported"
      exit 1;
  esac

  wifiessid="$1"
  hotspotessid="$2"
  wifipassword="$3"
  hotspotpassword="$4"
  channels=(1 6 11)
  channel=${channels[$((RANDOM % ${#channels[@]}))]};

  if [ -z "$hotspotessid" ];
  then
    echo "a hotspot essid is required"
    exit 1
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
  cp "$TEMPLATES/network/up-bridge.sh" /etc/up-bridge.sh

  echo "the bridge has been built ;), a reboot is required to apply changes"
}

function bridge_help {
  echo ""
  echo "Usage: $(basename "$0") bridge <WifiESSID> <HotspotESSID> [WifiPassword] [HotspotPassword]"
  echo ""
  echo "Bridges the wlan0 interface to ap0, creating a hotspot with desired configuration."
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") bridge MyWifi MyHotspot"
  echo "      This will connect to 'MyWifi' which is an open essid, and create an open hotspot called 'MyHotspot'"
  echo ""
  echo "  $(basename "$0") bridge MyWifi MyHotspot 12345678"
  echo "      This will connect to 'MyWifi' which has a password '12345678', and create an open hotspot called 'MyHotspot'"
  echo ""
  echo "  $(basename "$0") bridge MyWifi MyHotspot 12345678 hotspot123"
  echo "      This will connect to 'MyWifi' which has a password '12345678', and create a password hotspot called 'MyHotspot' with the password 'hotspot123'"
  echo ""
  echo "  $(basename "$0") bridge MyWifi MyHotspot \"\" 12345678"
  echo "      This will connect to 'MyWifi' which is an open essid, and create a password hotspot called 'MyHotspot' with the password '12345678'"
  echo ""
}