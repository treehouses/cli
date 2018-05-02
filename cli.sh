#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
TEMPLATES="$SCRIPTFOLDER/templates"

function help {
  echo "Usage: $(basename "$0")"
  echo
  echo "   expandfs                               expands the partition of the RPI image to the maximum of the SDcard"
  echo "   rename <hostname>                      changes hostname"
  echo "   password <password>                    change the password for 'pi' user"
  echo "   sshkeyadd <public_key>                 add a public key to 'pi' and 'root' user's authorized_keys"
  echo "   version                                returns the version of $(basename "$0") command"
  echo "   detectrpi                              detects the hardware version of a raspberry pi"
  echo "   wifi <ESSID> [password]                connects to a wifi network"
  echo "   container <none|docker|balena>         enables (and start) the desired container"
  echo "   bluetooth <on|off>                     switches between bluetooth hotspot mode / regular bluetooth and starts the service"
  echo "   ethernet <ip> <mask> <gateway> <dns>   configures rpi network interface to a static ip address"
  echo "   hotspot <ESSID> [password]             creates a mobile hotspot"
  echo "   upgrade                                upgrades $(basename "$0") package using npm"
  echo
  exit 1
}

function start_service {
  if [ "$(systemctl is-active "$1")" = "inactive" ]
  then
    systemctl start "$1" >/dev/null 2>/dev/null
  fi
}

function restart_service {
  systemctl stop "$1" >/dev/null 2>/dev/null
  systemctl start "$1" >/dev/null 2>/dev/null
}

function stop_service {
  if [ "$(systemctl is-active "$1")" = "active" ]
  then
    systemctl stop "$1" >/dev/null 2>/dev/null
  fi
}

function enable_service {
  if [ "$(systemctl is-enabled "$1")" = "disabled" ]
  then
    systemctl enable "$1" >/dev/null 2>/dev/null
  fi
}

function disable_service {
  if [ "$(systemctl is-enabled "$1")" = "enabled" ]
  then
    systemctl disable "$1" >/dev/null 2>/dev/null
  fi
}

function expandfs () {
  # expandfs is way too complex, it should be handled by raspi-config
  raspi-config --expand-rootfs >/dev/null 2>/dev/null
  echo "Success: the filesystem will be expanded on the next reboot"
  exit 0
}

function rename () {
  CURRENT_HOSTNAME=$(< /etc/hostname tr -d " \\t\\n\\r")
  echo "$1" > /etc/hostname
  sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\\t$1/g" /etc/hosts
  hostname "$1"
  echo "Success: the hostname has been modified"
  exit 0
}

function password () {
  echo "pi:$1" | chpasswd
  echo "Success: the password has been changed"
  exit 0
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
  systemctl disable hostapd
  systemctl disable dnsmasq
  restart_service dhcpcd
  stop_service hostapd
  stop_service dnsmasq
  ifup wlan0
  ifdown wlan0
  sleep 1
  ifup wlan0
}

function wifi {
  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces
  cp "$TEMPLATES/network/wlan0/default" /etc/network/interfaces.d/wlan0
  cp "$TEMPLATES/network/eth0/default" /etc/network/interfaces.d/eth0
  cp "$TEMPLATES/network/dhcpcd/modular" /etc/dhcpcd.conf
  cp "$TEMPLATES/network/dnsmasq/default" /etc/dnsmasq.conf
  cp "$TEMPLATES/rc.local/default" /etc/rc.local

  wifinetwork=$1
  wifipassword=$2

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

function rpi_bluetooth_discoverable {
  bluetoothctl <<EOF
    power on
    discoverable on
    pairable on
EOF
}

function bluetooth {
  status=$1
  if [ "$status" = "on" ]; then
    cp "$TEMPLATES/bluetooth/hotspot" /etc/systemd/system/dbus-org.bluez.service

    enable_service rpibluetooth
    restart_service bluetooth
    restart_service rpibluetooth

    sleep 5 # wait 5 seconds for bluetooth to be completely up

    # put rpi bluetooth on discoverable mode
    rpi_bluetooth_discoverable >/dev/null 2>/dev/null

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
  ifup eth0
  ifdown eth0
  sleep 1
  ifup eth0
}

function ethernet {
  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces
  cp "$TEMPLATES/network/eth0/static" /etc/network/interfaces.d/eth0
  sed -i "s/IPADDRESS/$1/g" /etc/network/interfaces.d/eth0
  sed -i "s/NETMASK/$2/g" /etc/network/interfaces.d/eth0
  sed -i "s/GATEWAY/$3/g" /etc/network/interfaces.d/eth0
  sed -i "s/GATEWAY/$4/g" /etc/network/interfaces.d/eth0
  restart_ethernet >/dev/null 2>/dev/null

  echo "This pirateship has anchored successfully!"
}

function restart_hotspot {
  restart_service dhcpcd
  ifdown wlan0
  sleep 1
  ifup wlan0
  sysctl net.ipv4.ip_forward=1
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
  iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
  restart_service dnsmasq
  restart_service hostapd
  enable_service hostapd
  enable_service dnsmasq
}

function hotspot {
  essid=$1
  password=$2
  channels=(1 6 11)
  channel=${channels[$(($RANDOM % ${#channels[@]}))]};

  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces 
  cp "$TEMPLATES/network/wlan0/hotspot" /etc/network/interfaces.d/wlan0
  cp "$TEMPLATES/network/dhcpcd/modular" /etc/dhcpcd.conf 
  cp "$TEMPLATES/network/dnsmasq/hotspot" /etc/dnsmasq.conf 
  cp "$TEMPLATES/network/hostapd/default" /etc/default/hostapd
  cp "$TEMPLATES/rc.local/hotspot" /etc/rc.local

  if [ -z "$password" ];
  then
    # FIXME: password should be >= 8 characters long
    # if (password.length < 8) {
    #   console.log("Error: Password must be over 8 characters long");
    #   return
    # };
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
}

function upgrade {
  npm install -g '@treehouses/cli'
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
  wifi)
    checkroot
    wifi "$2" "$3"
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
  upgrade)
    checkroot
    upgrade
    ;;
  *)
    help
    ;;
esac
