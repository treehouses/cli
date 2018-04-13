#!/bin/bash

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

function help {
  echo "Usage: $(basename $0)"
  echo
  echo "   expandfs                  expands the partition of the RPI image to the maximum of the SDcard"
  echo "   rename <hostname>         changes hostname"
  echo "   password <password>       change the password for 'pi' user"
  echo "   sshkeyadd <public_key>    add a public key to 'pi' and 'root' user's authorized_keys"
  echo "   version                   returns the version of $(basename $0) command"
  echo "   detectrpi                 detects the hardware version of a raspberry pi"
  echo
  exit 1
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
  *)
    help
    ;;
esac

