#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"

. "$SCRIPTFOLDER/modules/config.sh"
. "$SCRIPTFOLDER/modules/log.sh"
. "$SCRIPTFOLDER/modules/detectrpi.sh"
. "$SCRIPTFOLDER/modules/globals.sh"
. "$SCRIPTFOLDER/modules/ap.sh"
. "$SCRIPTFOLDER/modules/aphidden.sh"
. "$SCRIPTFOLDER/modules/apchannel.sh"
. "$SCRIPTFOLDER/modules/bluetooth.sh"
. "$SCRIPTFOLDER/modules/bluetoothid.sh"
. "$SCRIPTFOLDER/modules/bridge.sh"
. "$SCRIPTFOLDER/modules/burn.sh"
. "$SCRIPTFOLDER/modules/button.sh"
. "$SCRIPTFOLDER/modules/bootoption.sh"
. "$SCRIPTFOLDER/modules/container.sh"
. "$SCRIPTFOLDER/modules/default.sh"
. "$SCRIPTFOLDER/modules/detect.sh"
. "$SCRIPTFOLDER/modules/ethernet.sh"
. "$SCRIPTFOLDER/modules/expandfs.sh"
. "$SCRIPTFOLDER/modules/feedback.sh"
. "$SCRIPTFOLDER/modules/internet.sh"
. "$SCRIPTFOLDER/modules/help.sh"
. "$SCRIPTFOLDER/modules/image.sh"
. "$SCRIPTFOLDER/modules/led.sh"
. "$SCRIPTFOLDER/modules/locale.sh"
. "$SCRIPTFOLDER/modules/memory.sh"
. "$SCRIPTFOLDER/modules/temperature.sh"
. "$SCRIPTFOLDER/modules/networkmode.sh"
. "$SCRIPTFOLDER/modules/ntp.sh"
. "$SCRIPTFOLDER/modules/password.sh"
. "$SCRIPTFOLDER/modules/openvpn.sh"
. "$SCRIPTFOLDER/modules/rebootneeded.sh"
. "$SCRIPTFOLDER/modules/reboots.sh"
. "$SCRIPTFOLDER/modules/rename.sh"
. "$SCRIPTFOLDER/modules/restore.sh"
. "$SCRIPTFOLDER/modules/rtc.sh"
. "$SCRIPTFOLDER/modules/services.sh"
. "$SCRIPTFOLDER/modules/ssh.sh"
. "$SCRIPTFOLDER/modules/sshkey.sh"
. "$SCRIPTFOLDER/modules/sshtunnel.sh"
. "$SCRIPTFOLDER/modules/staticwifi.sh"
. "$SCRIPTFOLDER/modules/timezone.sh"
. "$SCRIPTFOLDER/modules/tor.sh"
. "$SCRIPTFOLDER/modules/upgrade.sh"
. "$SCRIPTFOLDER/modules/version.sh"
. "$SCRIPTFOLDER/modules/verbose.sh"
. "$SCRIPTFOLDER/modules/vnc.sh"
. "$SCRIPTFOLDER/modules/wifi.sh"
. "$SCRIPTFOLDER/modules/wificountry.sh"
. "$SCRIPTFOLDER/modules/wifihidden.sh"
. "$SCRIPTFOLDER/modules/wifistatus.sh"
. "$SCRIPTFOLDER/modules/clone.sh"
. "$SCRIPTFOLDER/modules/coralenv.sh"
. "$SCRIPTFOLDER/modules/speedtest.sh"
. "$SCRIPTFOLDER/modules/cron.sh"
. "$SCRIPTFOLDER/modules/discover.sh"
. "$SCRIPTFOLDER/modules/camera.sh"
. "$SCRIPTFOLDER/modules/usb.sh"
. "$SCRIPTFOLDER/modules/remote.sh"

case $1 in
  expandfs)
    checkrpi
    checkroot
    expandfs
    ;;
  rename)
    checkroot
    rename "$2"
    ;;
  password)
    checkrpi
    checkroot
    password "$2"
    ;;
  sshkey)
    checkroot
    shift
    sshkey "$@"
    ;;
  version)
    version
    ;;
  image)
    image
    ;;
  detect)
    detect
    ;;
  detectrpi)
    detectrpi
    ;;
  wifi)
    checkrpi
    checkroot
    wifi "$2" "$3"
    ;;
  wifihidden)
    checkrpi
    checkroot
    wifihidden "$2" "$3"
    ;;
  staticwifi)
    checkrpi
    checkroot
    staticwifi "$2" "$3" "$4" "$5" "$6" "$7"
    ;;
  container)
    checkroot
    container "$2"
    ;;
  bluetooth)
    checkwrpi
    checkroot
    bluetooth "$2" "$3"
    ;;
  bluetoothid)
    checkrpi
    bluetoothid "$2"
    ;;
  ethernet)
    checkrpi
    checkroot
    ethernet "$2" "$3" "$4" "$5"
    ;;
  ap)
    checkrpi
    checkroot
    shift
    ap "$@"
    ;;
  aphidden)
    checkrpi
    checkroot
    shift
    aphidden "$@"
    ;;
  discover)
    shift
    discover "$@"
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
  verbose)
    checkroot
    verbose "$2"
    ;;
  vnc)
    checkroot
    vnc "$2"
    ;;
  default)
    checkroot
    default "$2"
    ;;
  upgrade)
    shift
    upgrade "$@"
    ;;
  bridge)
    checkrpi
    checkroot
    shift
    bridge "$@"
    ;;
  wificountry)
    checkrpi
    checkroot
    wificountry "$2"
    ;;
  wifistatus)
    checkrpi
    wifistatus "$2"
    ;;
  sshtunnel)
    checkroot
    sshtunnel "$2" "$3" "$4"
    ;;
  led)
    checkrpi
    led "$2" "$3"
    ;;
  rtc)
    checkrpi
    checkroot
    rtc "$2" "$3"
    ;;
  ntp)
    checkrpi
    checkroot
    ntp "$2"
    ;;
  networkmode)
    networkmode "$2"
    ;;
  button)
    checkrpi
    checkroot
    button "$2"
    ;;
  feedback)
    shift
    feedback "$*"
    ;;
  apchannel)
    checkrpi
    shift
    apchannel "$1"
    ;;
  clone)
    checkrpi
    checkroot
    shift
    clone "$1"
    ;;
  restore)
    checkrpi
    checkroot
    shift
    restore "$1"
    ;;
  burn)
    checkrpi
    checkroot
    shift
    burn "$1"
    ;;
  rebootneeded)
    rebootneeded
    ;;
  reboots)
    reboots "$2" "$3"
    ;;
  internet)
    internet
    ;;
  services)
    shift
    services "$@"
    ;;
  tor)
    checkroot
    shift
    tor "$@"
    ;;
  bootoption)
    checkrpi
    checkroot
    shift
    bootoption "$*"
    ;;
  openvpn)
    checkroot
    shift
    openvpn "$@"
    ;;
  coralenv)
    checkrpi
    checkroot
    shift
    coralenv "$@"
    ;;
  memory)
    shift
    memory "$@"
    ;;
  temperature)
    checkrpi
    temperature "$2"
    ;;
  speedtest)
    shift
    speedtest "$@"
    ;;
  camera)
    checkrpi
    camera "$2"
    ;;
  cron)
    checkroot
    cron "$2" "$3"
    ;;
  usb)
    checkroot
    usb "$2"
    ;;
  remote)
    checkroot
    checkrpi
    remote "$2" "$3"
    ;;
  log)
    checkroot
    log "$2" "$3"
    ;;
  help)
    help "$2"
    ;;
  *)
    help
    ;;
esac
if [ $? -eq 0 ]; then
  logit "$SCRIPTARGS" "1"
fi
