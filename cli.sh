#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
TEMPLATES="$SCRIPTFOLDER/templates"

function help {
  echo "Usage: $(basename "$0")"
  echo
  echo "   expandfs                                 expands the partition of the RPI image to the maximum of the SDcard"
  echo "   rename <hostname>                        changes hostname"
  echo "   password <password>                      change the password for 'pi' user"
  echo "   sshkeyadd <public_key>                   add a public key to 'pi' and 'root' user's authorized_keys"
  echo "   version                                  returns the version of $(basename "$0") command"
  echo "   detectrpi                                detects the hardware version of a raspberry pi"
  echo "   ethernet <ip> <mask> <gateway> <dns>     configures rpi network interface to a static ip address"
  echo "   wifi <ESSID> [password]                  connects to a wifi network"
  echo "   staticwifi <ip> <mask> <gateway> <dns>   configures rpi wifi interface to a static ip address"
  echo "              <ESSID> [password]"
  echo "   container <none|docker|balena>           enables (and start) the desired container"
  echo "   bluetooth <on|off>                       switches between bluetooth hotspot mode / regular bluetooth and starts the service"
  echo "   hotspot <ESSID> [password]               creates a mobile hotspot"
  echo "   timezone <timezone>                      sets the timezone of the system"
  echo "   locale <locale>                          sets the system locale"
  echo "   ssh <on|off>                             enables or disables the ssh service"
  echo "   vnc <on|off>                             enables or disables the vnc server service"
  echo "   default                                  sets a raspbian back to default configuration"
  echo "   upgrade                                  upgrades $(basename "$0") package using npm"
  echo "   checksignal                              check the wifi signal strength of your RPi"
  echo
  exit 0
}

function start_service {
  if [ "$(systemctl is-active "$1" 2>/dev/null)" = "inactive" ]
  then
    systemctl start "$1" >/dev/null 2>/dev/null
  fi
}

function restart_service {
  systemctl stop "$1" >/dev/null 2>/dev/null
  systemctl start "$1" >/dev/null 2>/dev/null
}

function stop_service {
  if [ "$(systemctl is-active "$1" 2>/dev/null)" = "active" ]
  then
    systemctl stop "$1" >/dev/null 2>/dev/null
  fi
}

function enable_service {
  if [ "$(systemctl is-enabled "$1" 2>/dev/null)" = "disabled" ]
  then
    systemctl enable "$1" >/dev/null 2>/dev/null
  fi
}

function disable_service {
  if [ "$(systemctl is-enabled "$1" 2>/dev/null)" = "enabled" ]
  then
    systemctl disable "$1" >/dev/null 2>/dev/null
  fi
}

function expandfs () {
  # expandfs is way too complex, it should be handled by raspi-config
  raspi-config --expand-rootfs >/dev/null 2>/dev/null
  echo "Success: the filesystem will be expanded on the next reboot"
}

function rename () {
  CURRENT_HOSTNAME=$(< /etc/hostname tr -d " \\t\\n\\r")
  echo "$1" > /etc/hostname
  sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\\t$1/g" /etc/hosts
  hostname "$1"
  echo "Success: the hostname has been modified"
}

function password () {
  echo "pi:$1" | chpasswd
  echo "Success: the password has been changed"
}

function sshkeyadd () {
  mkdir -p /root/.ssh /home/pi/.ssh
  chmod 700 /root/.ssh /home/pi/.ssh

  echo "$@" >> /home/pi/.ssh/authorized_keys
  chmod 600 /home/pi/.ssh/authorized_keys
  chown -R pi:pi /home/pi/.ssh

  echo "$@" >> /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys

  echo "====== Added to 'pi' and 'root' user's authorized_keys ======"
  echo "$@"
}

function version {
  npm info '@treehouses/cli' version
}

function checkroot {
  if [ "$(id -u)" -ne 0 ];
  then
      echo "Error: Must be run with root permissions"
      exit 1
  fi
}

function detectrpi {
  declare -A rpimodels
  rpimodels["Beta"]="BETA"
  rpimodels["0002"]="RPIB"
  rpimodels["0003"]="RPIB"
  rpimodels["0004"]="RPIB"
  rpimodels["0005"]="RPIB"
  rpimodels["0006"]="RPIB"
  rpimodels["0007"]="RPIA"
  rpimodels["0008"]="RPIA"
  rpimodels["0009"]="RPIA"
  rpimodels["000d"]="RPIB"
  rpimodels["000e"]="RPIB"
  rpimodels["000f"]="RPIB"
  rpimodels["0010"]="RPIB+"
  rpimodels["0011"]="CM"
  rpimodels["0012"]="RPIA+"
  rpimodels["0013"]="RPIB+"
  rpimodels["0014"]="CM"
  rpimodels["0015"]="RPIA+"
  rpimodels["a01040"]="RPI2B"
  rpimodels["a01041"]="RPI2B"
  rpimodels["a21041"]="RPI2B"
  rpimodels["a22042"]="RPI2B"
  rpimodels["900021"]="RPIA+"
  rpimodels["900032"]="RPIB+"
  rpimodels["900092"]="RPIZ"
  rpimodels["900093"]="RPIZ"
  rpimodels["920093"]="RPIZ"
  rpimodels["9000c1"]="RPIZW"
  rpimodels["a02082"]="RPI3B"
  rpimodels["a020a0"]="CM3"
  rpimodels["a22082"]="RPI3B"
  rpimodels["a32082"]="RPI3B"
  rpimodels["a020d3"]="RPI3B+"

  rpimodel=$(grep Revision /proc/cpuinfo | sed 's/.* //g' | tr -d '\n')

  echo ${rpimodels[$rpimodel]}
}

function restart_wifi {
  systemctl disable hostapd || true
  systemctl disable dnsmasq || true
  restart_service dhcpcd
  stop_service hostapd
  stop_service dnsmasq
  ifup wlan0 || true
  ifdown wlan0 || true
  sleep 1
  ifup wlan0 || true
}

function wifi {
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
    restart_wifi >/dev/null 2>/dev/null
    echo "open wifi network"
  else
    wpa_passphrase "$wifinetwork" "$wifipassword" >> /etc/wpa_supplicant/wpa_supplicant.conf
    restart_wifi >/dev/null 2>/dev/null
    echo "password network"
  fi
}

function container {
  container=$1
  if [ "$container" = "docker" ]; then
    disable_service balena
    stop_service balena
    enable_service docker
    start_service docker
    echo "Success: docker has been enabled and started."
  elif [ "$container" = "balena" ]; then
    disable_service docker
    stop_service docker
    enable_service balena
    start_service balena
    echo "Success: balena has been enabled and started."
  elif [ "$container" = "none" ]; then
    disable_service balena
    disable_service docker
    stop_service docker
    stop_service balena
    echo "Success: docker and balena have been disabled and stopped."
  else
    echo "Error: only 'docker', 'balena', 'none' options are supported";
  fi
}

function bluetooth {
  status=$1
  if [ "$status" = "on" ]; then
    cp "$TEMPLATES/bluetooth/hotspot" /etc/systemd/system/dbus-org.bluez.service

    enable_service rpibluetooth
    restart_service bluetooth
    restart_service rpibluetooth

    sleep 5 # wait 5 seconds for bluetooth to be completely up

    echo "Success: the bluetooth service, and the hotspot service have been started."
  elif [ "$status" = "off" ]; then
    cp "$TEMPLATES/bluetooth/default" /etc/systemd/system/dbus-org.bluez.service

    disable_service rpibluetooth
    stop_service rpibluetooth
    restart_service bluetooth

    sleep 3 # Wait few seconds for bluetooth to start
    restart_service bluealsa # restart the bluetooth audio service

    echo "Success: the bluetooth service has been switched to default, and the hotspot service has been stopped."
  else
    echo "Error: only 'on', 'off' options are supported";
  fi
}

function restart_ethernet {
  ifup eth0 || true
  ifdown eth0 || true
  sleep 1
  ifup eth0 || true
}

function ethernet {
  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces
  cp "$TEMPLATES/network/eth0/static" /etc/network/interfaces.d/eth0
  sed -i "s/IPADDRESS/$1/g" /etc/network/interfaces.d/eth0
  sed -i "s/NETMASK/$2/g" /etc/network/interfaces.d/eth0
  sed -i "s/GATEWAY/$3/g" /etc/network/interfaces.d/eth0
  sed -i "s/DNS/$4/g" /etc/network/interfaces.d/eth0
  restart_ethernet >/dev/null 2>/dev/null

  echo "This pirateship has anchored successfully!"
}

function restart_hotspot {
  restart_service dhcpcd || true
  ifdown wlan0 || true
  sleep 1 || true
  ifup wlan0 || true
  sysctl net.ipv4.ip_forward=1 || true
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE || true
  iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT || true
  iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT || true
  restart_service dnsmasq || true
  restart_service hostapd || true
  enable_service hostapd || true
  enable_service dnsmasq || true
}

function hotspot {
  essid=$1
  password=$2
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
  cp "$TEMPLATES/network/wlan0/hotspot" /etc/network/interfaces.d/wlan0
  cp "$TEMPLATES/network/eth0/default" /etc/network/interfaces.d/eth0
  cp "$TEMPLATES/network/dhcpcd/modular" /etc/dhcpcd.conf 
  cp "$TEMPLATES/network/dnsmasq/hotspot" /etc/dnsmasq.conf 
  cp "$TEMPLATES/network/hostapd/default" /etc/default/hostapd
  cp "$TEMPLATES/rc.local/hotspot" /etc/rc.local

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

function timezone {
  timezone="$1"
  if [ -z "$timezone" ];
  then
    echo "Error: the timezone is missing"
    exit 1;
  fi

  if [ ! -f "/usr/share/zoneinfo/$timezone" ];
  then
    echo "Error: the timezone is not supported"
    exit 1;
  fi

  rm /etc/localtime
  echo "$timezone" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata 2>/dev/null
  echo "Success: the timezone has been set"
}

function locale {
  locale="$1"
  if [ -z "$locale" ];
  then
    echo "Error: the locale is missing"
    exit 1
  fi

  if ! locale_line="$(grep "^$locale " /usr/share/i18n/SUPPORTED)";
  then
    echo "Error: the specified locale is not supported"
    exit 1
  fi

  encoding="$(echo "$locale_line" | cut -f2 -d " ")"
  echo "$locale $encoding" > /etc/locale.gen
  sed -i "s/^\\s*LANG=\\S*/LANG=$locale/" /etc/default/locale
  dpkg-reconfigure -f noninteractive locales -q 2>/dev/null
  echo "Success: the locale has been changed"
}

function checksignal {
  arrayInfo=$1
   info=$(iwconfig wlan0)
   IFS=$'\n'
   read -d '' -r -a arrayInfo <<<"$info"

   SSID=${arrayInfo:10:100}
   signal=${arrayInfo[6]:30:52}

   if [[ "${arrayInfo[*]}" == *"ESSID:off/any"* ]]; then
     echo "you are not on a wireless connection"
   fi

   else:
   echo "$SSID"
   echo "$signal"
}

function ssh {
  status=$1
  if [ "$status" = "on" ]; then
    enable_service ssh
    start_service ssh
    echo "Success: the ssh service has been started and enabled when the system boots"
  elif [ "$status" = "off" ]; then
    disable_service ssh
    stop_service ssh
    echo "Success: the ssh service has been stopped and disabled when the system boots."
  else
    echo "Error: only 'on', 'off' options are supported";
  fi
}

function vnc {
  status=$1
  if [ ! -d /usr/share/doc/realvnc-vnc-server ] ; then
    echo "Error: the vnc server is not installed, to install it run:"
    echo "apt-get install realvnc-vnc-server"
    exit 1;
  fi

  if [ "$status" = "on" ]; then
    enable_service vncserver-x11-serviced.service
    start_service vncserver-x11-serviced.service
    echo "Success: the vnc service has been started and enabled when the system boots"
  elif [ "$status" = "off" ]; then
    disable_service vncserver-x11-serviced.service
    stop_service vncserver-x11-serviced.service
    echo "Success: the vnc service has been stopped and disabled when the system boots."
  else
    echo "Error: only 'on', 'off' options are supported";
  fi
}

function default {
  cp "$TEMPLATES/network/interfaces/default" "/etc/network/interfaces"
  cp "$TEMPLATES/network/wpa_supplicant" "/etc/wpa_supplicant/wpa_supplicant.conf"
  cp "$TEMPLATES/rc.local/default" "/etc/rc.local"
  cp "$TEMPLATES/network/dnsmasq/default" "/etc/dnsmasq.conf"
  cp "$TEMPLATES/network/dhcpcd/default" "/etc/dhcpcd.conf"
  rm -rf /etc/hostapd.conf
  rm -rf /etc/network/interfaces.d/*
  rm -rf /etc/rpi-wifi-country
  rename "raspberrypi" > /dev/null 2>/dev/null
  bluetooth "off" > /dev/null 2>/dev/null
  stop_service hostapd
  stop_service dnsmasq
  disable_service hostapd
  disable_service dnsmasq
  restart_wifi >/dev/null 2>/dev/null
  restart_ethernet >/dev/null 2>/dev/null

  echo 'Success: the rpi has been reset to default, please reboot your device'
}

function upgrade {
  npm install -g '@treehouses/cli'
}


function staticwifi {
  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces
  cp "$TEMPLATES/network/wlan0/static" /etc/network/interfaces.d/wlan0
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
      echo "  ssid=\"$wifinetwork\""
      echo "  key_mgmt=NONE"
      echo "}"
    } >> /etc/wpa_supplicant/wpa_supplicant.conf
  else
    wpa_passphrase "$essid" "$password" >> /etc/wpa_supplicant/wpa_supplicant.conf
  fi

  restart_wifi >/dev/null 2>/dev/null

  echo "Success: the wifi settings have been changed, a reboot is required in order to see the changes"
}

case $1 in
  expandfs)
    checkroot
    expandfs
    ;;
  rename)
    checkroot
    rename "$2"
    ;;
  password)
    checkroot
    password "$2"
    ;;
  sshkeyadd)
    checkroot
    shift
    sshkeyadd "$@"
    ;;
  version)
    version
    ;;
  detectrpi)
    detectrpi
    ;;
  checksignal)
    checksignal "$@"
    ;;
  wifi)
    checkroot
    wifi "$2" "$3"
    ;;
  staticwifi)
    checkroot
    staticwifi "$2" "$3" "$4" "$5" "$6" "$7"
    ;;
  container)
    checkroot
    container "$2"
    ;;
  bluetooth)
    checkroot
    bluetooth "$2"
    ;;
  ethernet)
    checkroot
    ethernet "$2" "$3" "$4" "$5"
    ;;
  hotspot)
    checkroot
    hotspot "$2" "$3"
    ;;
  timezone)
    checkroot
    timezone "$2"
    ;;
  locale)
    checkroot
    locale "$2"
    ;;
  ssh)
    checkroot
    ssh "$2"
    ;;
  vnc)
    checkroot
    vnc "$2"
    ;;
  default)
    checkroot
    default
    ;;
  upgrade)
    checkroot
    upgrade
    ;;
  *)
    help
    ;;
esac
