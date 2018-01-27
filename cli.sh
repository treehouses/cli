#!/bin/bash

function expandfs () {
  if ! [ -h /dev/root ]; then
    echo "Error: /dev/root does not exist or is not a symlink. Don't know how to expand"
    exit 1
  fi

  ROOT_PART=$(readlink /dev/root)
  PART_NUM=${ROOT_PART#mmcblk0p}
  if [ "$PART_NUM" = "$ROOT_PART" ]; then
    echo "Error: /dev/root is not an SD card. Don't know how to expand"
    exit 1
  fi

  if [ "$PART_NUM" -ne 2 ]; then
    echo "Error: Your partition layout is not currently supported by this tool. You are probably using NOOBS, in which case your root filesystem is already expanded anyway."
    exit 1
  fi

  LAST_PART_NUM=$(parted /dev/mmcblk0 -ms unit s p | tail -n 1 | cut -f 1 -d:)

  if [ "$LAST_PART_NUM" != "$PART_NUM" ]; then
    echo "Error: /dev/root is not the last partition. Don't know how to expand"
    exit 1
  fi

  # Get the starting offset of the root partition
  PART_START=$(parted /dev/mmcblk0 -ms unit s p | grep "^${PART_NUM}" | cut -f 2 -d:)
  [ "$PART_START" ] || exit 1

  fdisk /dev/mmcblk0 <<EOF
p
d
$PART_NUM
n
p
$PART_NUM
$PART_START
p
w
EOF

  # now set up an init.d script
cat <<\EOF > /etc/init.d/resize2fs_once &&
#!/bin/sh
### BEGIN INIT INFO
# Provides:          resize2fs_once
# Required-Start:
# Required-Stop:
# Default-Start: 2 3 4 5 S
# Default-Stop:
# Short-Description: Resize the root filesystem to fill partition
# Description:
### END INIT INFO
. /lib/lsb/init-functions
case "$1" in
  start)
    log_daemon_msg "Starting resize2fs_once" &&
    resize2fs /dev/root &&
    rm /etc/init.d/resize2fs_once &&
    update-rc.d resize2fs_once remove &&
    log_end_msg $?
    ;;
  *)
    echo "Usage: $0 start" >&2
    exit 3
    ;;
esac
EOF
  chmod +x /etc/init.d/resize2fs_once &&
  update-rc.d resize2fs_once defaults &&
  if [ "$INTERACTIVE" = True ]; then
    echo -e "Success: Root partition has been resized.\\nThe filesystem will be enlarged upon the next reboot"
    exit 0
  fi
}

function rename () {
  CURRENT_HOSTNAME=$(cat /etc/hostname | tr -d " \t\n\r")
  echo $1 > /etc/hostname
  sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$1/g" /etc/hosts
  hostname $1
  echo "Success: the hostname has been modified"
  exit 1
}

function password () {
  echo "pi:$1" | chpasswd
  echo "password change success"
  exit 1
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
  exit 0
}

function checkroot {
  if [[ $EUID -ne 0 ]];
  then
      echo "Error: Must be run with root permissions"
      exit 0
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

