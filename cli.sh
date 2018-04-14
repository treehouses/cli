#!/bin/bash

function help {
  echo "Usage: $(basename $0)"
  echo
  echo "   expandfs                          expands the partition of the RPI image to the maximum of the SDcard"
  echo "   rename <hostname>                 changes hostname"
  echo "   password <password>               change the password for 'pi' user"
  echo "   sshkeyadd <public_key>            add a public key to 'pi' and 'root' user's authorized_keys"
  echo "   version                           returns the version of $(basename $0) command"
  echo "   detectrpi                         detects the hardware version of a raspberry pi"
  echo "   wifi <ESSID> [password]           connects to a wifi network"
  echo "   container <none|docker|balena>    enables (and start) the desired container"
  echo
  exit 1
}

function start_service {
  if [ "`systemctl is-active $1`" == "inactive" ]
  then
    systemctl start $1 >/dev/null 2>/dev/null
  fi
}

function restart_service {
  systemctl stop $1 >/dev/null 2>/dev/null
  systemctl start $1 >/dev/null 2>/dev/null
}

function stop_service {
  if [ "`systemctl is-active $1`" == "active" ]
  then
    systemctl stop $1 >/dev/null 2>/dev/null
  fi
}

function enable_service {
  if [ "`systemctl is-enabled $1`" == "disabled" ]
  then
    systemctl enable $1 >/dev/null 2>/dev/null
  fi
}

function disable_service {
  if [ "`systemctl is-enabled $1`" == "enabled" ]
  then
    systemctl disable $1 >/dev/null 2>/dev/null
  fi
}

function expandfs () {
  # expandfs is way too complex, it should be handled by raspi-config
  raspi-config --expand-rootfs >/dev/null 2>/dev/null
  echo "Success: the filesystem will be expanded on the next reboot"
  exit 0
}

function rename () {
  CURRENT_HOSTNAME=$(cat /etc/hostname | tr -d " \t\n\r")
  echo $1 > /etc/hostname
  sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$1/g" /etc/hosts
  hostname $1
  echo "Success: the hostname has been modified"
  exit 0
}

function password () {
  echo "pi:$1" | chpasswd
  echo "password change success"
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
  echo $(npm info '@treehouses/cli' version)
}

function checkroot {
  if [ $(id -u) -ne 0 ];
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

  rpimodel=$(cat /proc/cpuinfo | grep Revision | sed 's/.* //g' | tr -d '\n')

  echo ${rpimodels[$rpimodel]}
}

function restart_wifi {
  systemctl disable hostapd || true
  systemctl disable dnsmasq || true
  service dhcpcd restart || true
  service hostapd stop || true
  service dnsmasq stop || true
  ifup wlan0 || true
  ifdown wlan0 || true
  sleep 1
  ifup wlan0 || true
}

function wifi {
  {
    echo "source /etc/network/interfaces.d/*"
  } > /etc/network/interfaces

  {
    echo "allow-hotplug wlan0"
    echo "auto wlan0"
    echo "iface wlan0 inet dhcp"
    echo "    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf"
  } > /etc/network/interfaces.d/wlan0

  {
    echo "auto eth0"
    echo "  allow-hotplug eth0"
    echo "  iface eth0 inet dhcp"
  } > /etc/network/interfaces.d/eth0


  {
    echo "hostname"
    echo "clientid"
    echo "persistent"
    echo "option rapid_commit"
    echo "option domain_name_servers, domain_name, domain_search, host_name"
    echo "option classless_static_routes"
    echo "option ntp_servers"
    echo "option interface_mtu"
    echo "require dhcp_server_identifier"
    echo "slaac private"
    echo "denyinterfaces wlan0 eth0"
  } > /etc/dhcpcd.conf


  echo > /etc/dnsmasq.conf

  {
    echo '#!/bin/sh -e'
    echo "_IP=\$(hostname -I) || true"
    echo "if [ \"\$_IP\" ]; then"
    echo "  printf \"My IP address is %s\n\" \"\$_IP\""
    echo "fi"
    echo "exit 0"
  } > /etc/rc.local

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
  if [ $container = "docker" ]; then
    disable_service balena
    stop_service balena
    enable_service docker
    start_service docker
    echo "Success: docker has been enabled and started."
  elif [ $container = "balena" ]; then
    disable_service docker
    stop_service docker
    enable_service balena
    start_service balena
    echo "Success: balena has been enabled and started."
  elif [ $container = "none" ]; then
    disable_service balena
    disable_service docker
    stop_service docker
    stop_service balena
    echo "Success: docker and balena have been disabled and stopped."
  else
    echo "Error: only 'docker', 'balena', 'none' options are supported";
  fi
}

case $1 in
  expandfs)
    checkroot
    expandfs
    ;;
  rename)
    checkroot
    rename $2
    ;;
  password)
    checkroot
    password $2
    ;;
  sshkeyadd)
    checkroot
    shift
    sshkeyadd $@
    ;;
  version)
    version
    ;;
  detectrpi)
    detectrpi
    ;;
  wifi)
    checkroot
    wifi $2 $3
    ;;
  container)
    checkroot
    container $2
    ;;
  *)
    help
    ;;
esac

