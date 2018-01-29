#!/bin/bash

function expandfs () {
  # expandfs is way too complex, it should be handled by raspi-config
  raspi-config --expand-rootfs 2>&1 >/dev/null
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

function help {
  echo "Usage: $(basename $0) " >&2
  echo
  echo "   expandfs                  expands the partition of the RPI image to the maximum of the SDcard"
  echo "   rename <hostname>         changes hostname"
  echo "   password <password>       change the password for 'pi' user"
  echo "   sshkeyadd <public_key>    add a public key to 'pi' and 'root' user's authorized_keys"
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
  *)
    help
    ;;
esac

