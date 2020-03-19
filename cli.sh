#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"
SCRIPTARGNUM=$#

source "$SCRIPTFOLDER/modules/config.sh"
source "$SCRIPTFOLDER/modules/log.sh"
source "$SCRIPTFOLDER/modules/detectbluetooth.sh"
source "$SCRIPTFOLDER/modules/detectrpi.sh"
source "$SCRIPTFOLDER/modules/globals.sh"
source "$SCRIPTFOLDER/modules/ap.sh"
source "$SCRIPTFOLDER/modules/aphidden.sh"
source "$SCRIPTFOLDER/modules/apchannel.sh"
source "$SCRIPTFOLDER/modules/bluetooth.sh"
source "$SCRIPTFOLDER/modules/bluetoothid.sh"
source "$SCRIPTFOLDER/modules/bridge.sh"
source "$SCRIPTFOLDER/modules/burn.sh"
source "$SCRIPTFOLDER/modules/button.sh"
source "$SCRIPTFOLDER/modules/bootoption.sh"
source "$SCRIPTFOLDER/modules/container.sh"
source "$SCRIPTFOLDER/modules/default.sh"
source "$SCRIPTFOLDER/modules/detect.sh"
source "$SCRIPTFOLDER/modules/ethernet.sh"
source "$SCRIPTFOLDER/modules/expandfs.sh"
source "$SCRIPTFOLDER/modules/feedback.sh"
source "$SCRIPTFOLDER/modules/internet.sh"
source "$SCRIPTFOLDER/modules/help.sh"
source "$SCRIPTFOLDER/modules/image.sh"
source "$SCRIPTFOLDER/modules/led.sh"
source "$SCRIPTFOLDER/modules/locale.sh"
source "$SCRIPTFOLDER/modules/memory.sh"
source "$SCRIPTFOLDER/modules/temperature.sh"
source "$SCRIPTFOLDER/modules/networkmode.sh"
source "$SCRIPTFOLDER/modules/ntp.sh"
source "$SCRIPTFOLDER/modules/password.sh"
source "$SCRIPTFOLDER/modules/openvpn.sh"
source "$SCRIPTFOLDER/modules/rebootneeded.sh"
source "$SCRIPTFOLDER/modules/reboots.sh"
source "$SCRIPTFOLDER/modules/rename.sh"
source "$SCRIPTFOLDER/modules/restore.sh"
source "$SCRIPTFOLDER/modules/rtc.sh"
source "$SCRIPTFOLDER/modules/services.sh"
source "$SCRIPTFOLDER/modules/ssh.sh"
source "$SCRIPTFOLDER/modules/sshkey.sh"
source "$SCRIPTFOLDER/modules/sshtunnel.sh"
source "$SCRIPTFOLDER/modules/staticwifi.sh"
source "$SCRIPTFOLDER/modules/timezone.sh"
source "$SCRIPTFOLDER/modules/tor.sh"
source "$SCRIPTFOLDER/modules/upgrade.sh"
source "$SCRIPTFOLDER/modules/version.sh"
source "$SCRIPTFOLDER/modules/verbose.sh"
source "$SCRIPTFOLDER/modules/vnc.sh"
source "$SCRIPTFOLDER/modules/wifi.sh"
source "$SCRIPTFOLDER/modules/wificountry.sh"
source "$SCRIPTFOLDER/modules/wifihidden.sh"
source "$SCRIPTFOLDER/modules/wifistatus.sh"
source "$SCRIPTFOLDER/modules/clone.sh"
source "$SCRIPTFOLDER/modules/coralenv.sh"
source "$SCRIPTFOLDER/modules/speedtest.sh"
source "$SCRIPTFOLDER/modules/cron.sh"
source "$SCRIPTFOLDER/modules/discover.sh"
source "$SCRIPTFOLDER/modules/camera.sh"
source "$SCRIPTFOLDER/modules/usb.sh"
source "$SCRIPTFOLDER/modules/remote.sh"
source "$SCRIPTFOLDER/modules/blocker.sh"
source "$SCRIPTFOLDER/modules/sdbench.sh"

for f in $SCRIPTFOLDER/modules/*
do
  cmd=$(basename "$f")
  cmd=${cmd%%.*}
  if [ "$cmd" = "$1" ]; then
    find=1
    shift
    eval "$cmd" $@
  fi
done
if [ find != 1 ]; then
  help
fi

if [ $? -eq 0 ]; then
  logit "$SCRIPTARGS" "1"
fi
