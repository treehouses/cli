#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")

source "$SCRIPTFOLDER/modules/globals.sh"
source "$SCRIPTFOLDER/modules/ap.sh"
source "$SCRIPTFOLDER/modules/bluetooth.sh"
source "$SCRIPTFOLDER/modules/bridge.sh"
source "$SCRIPTFOLDER/modules/container.sh"
source "$SCRIPTFOLDER/modules/default.sh"
source "$SCRIPTFOLDER/modules/detectrpi.sh"
source "$SCRIPTFOLDER/modules/ethernet.sh"
source "$SCRIPTFOLDER/modules/expandfs.sh"
source "$SCRIPTFOLDER/modules/help.sh"
source "$SCRIPTFOLDER/modules/image.sh"
source "$SCRIPTFOLDER/modules/led.sh"
source "$SCRIPTFOLDER/modules/locale.sh"
source "$SCRIPTFOLDER/modules/networkmode.sh"
source "$SCRIPTFOLDER/modules/ntp.sh"
source "$SCRIPTFOLDER/modules/password.sh"
source "$SCRIPTFOLDER/modules/rename.sh"
source "$SCRIPTFOLDER/modules/rtc.sh"
source "$SCRIPTFOLDER/modules/ssh.sh"
source "$SCRIPTFOLDER/modules/sshkeyadd.sh"
source "$SCRIPTFOLDER/modules/sshtunnel.sh"
source "$SCRIPTFOLDER/modules/staticwifi.sh"
source "$SCRIPTFOLDER/modules/timezone.sh"
source "$SCRIPTFOLDER/modules/upgrade.sh"
source "$SCRIPTFOLDER/modules/version.sh"
source "$SCRIPTFOLDER/modules/vnc.sh"
source "$SCRIPTFOLDER/modules/wifi.sh"
source "$SCRIPTFOLDER/modules/wificountry.sh"



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
  image)
    image
    ;;
  detectrpi)
    detectrpi
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
  ap)
    checkroot
    ap "$2" "$3" "$4"
    ;;
  hotspot)
    checkroot
    ap "local" "$2" "$3"
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
    shift
    upgrade "$@"
    ;;
  bridge)
    checkroot
    bridge "$2" "$3" "$4" "$5"
    ;;
  wificountry)
    checkroot
    wificountry "$2"
    ;;
  sshtunnel)
    checkroot
    sshtunnel "$2" "$3" "$4"
    ;;
  led)
    led "$2" "$3"
    ;;
  rtc)
    checkroot
    rtc "$2" "$3"
    ;;
  ntp)
    checkroot
    ntp "$2"
    ;;
  networkmode)
    networkmode
    ;;
  help)
    help "$2"
    ;;
  *)
    help
    ;;
esac
