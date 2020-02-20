#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"
SCRIPTARGNUM=$#

source "$SCRIPTFOLDER/modules/config.sh"
source "$SCRIPTFOLDER/modules/log.sh"
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
echo "$#"
case $1 in
  expandfs)
    checkrpi
    checkroot
    checkargn 1
    expandfs
    ;;
  rename)
    checkroot
    checkargn 2
    rename "$2"
    ;;
  password)
    checkrpi
    checkroot
    checkargn 2
    password "$2"
    ;;
  sshkey)
    checkroot
    checkargn 6
    shift
    sshkey "$@"
    ;;
  version)
    checkargn 1
    version
    ;;
  image)
    checkargn 1
    image
    ;;
  detect)
    checkargn 1
    detect
    ;;
  detectrpi)
    checkargn 2
    detectrpi "$2"
    ;;
  wifi)
    checkrpi
    checkroot
    checkargn 3
    wifi "$2" "$3"
    ;;
  wifihidden)
    checkrpi
    checkroot
    checkargn 3
    wifihidden "$2" "$3"
    ;;
  staticwifi)
    checkrpi
    checkroot
    checkargn 7
    staticwifi "$2" "$3" "$4" "$5" "$6" "$7"
    ;;
  container)
    checkroot
    checkargn 2
    container "$2"
    ;;
  bluetooth)
    checkwrpi
    checkroot
    checkargn 3
    bluetooth "$2" "$3"
    ;;
  bluetoothid)
    checkrpi
    checkargn 2
    bluetoothid "$2"
    ;;
  ethernet)
    checkrpi
    checkroot
    checkargn 5
    ethernet "$2" "$3" "$4" "$5"
    ;;
  ap)
    checkrpi
    checkroot
    checkargn 5
    shift
    ap "$@"
    ;;
  aphidden)
    checkrpi
    checkroot
    checkargn 5
    shift
    aphidden "$@"
    ;;
  discover)
    checkargn 3
    shift
    discover "$@"
    ;;
  timezone)
    checkroot
    checkargn 2
    timezone "$2"
    ;;
  locale)
    checkroot
    checkargn 2
    locale "$2"
    ;;
  ssh)
    checkroot
    checkargn 2
    ssh "$2"
    ;;
  verbose)
    checkroot
    checkargn 2
    verbose "$2"
    ;;
  vnc)
    checkroot
    checkargn 2
    vnc "$2"
    ;;
  default)
    checkroot
    checkargn 2
    default "$2"
    ;;
  upgrade)
    checkargn 2
    shift
    upgrade "$@"
    ;;
  bridge)
    checkrpi
    checkroot
    checkargn 6
    shift
    bridge "$@"
    ;;
  wificountry)
    checkrpi
    checkroot
    checkargn 2
    wificountry "$2"
    ;;
  wifistatus)
    checkrpi
    checkargn 2
    wifistatus "$2"
    ;;
  sshtunnel)
    checkroot
    checkargn 4
    sshtunnel "$2" "$3" "$4"
    ;;
  led)
    checkrpi
    checkargn 3
    led "$2" "$3"
    ;;
  rtc)
    checkrpi
    checkroot
    checkargn 3
    rtc "$2" "$3"
    ;;
  ntp)
    checkrpi
    checkroot
    checkargn 2
    ntp "$2"
    ;;
  networkmode)
    checkargn 2
    networkmode "$2"
    ;;
  button)
    checkrpi
    checkroot
    checkargn 2
    button "$2"
    ;;
  feedback)
    checkargn 2
    shift
    feedback "$*"
    ;;
  apchannel)
    checkrpi
    checkargn 2
    shift
    apchannel "$1"
    ;;
  clone)
    checkrpi
    checkroot
    checkargn 2
    shift
    clone "$1"
    ;;
  restore)
    checkrpi
    checkroot
    checkargn 2
    shift
    restore "$1"
    ;;
  burn)
    checkrpi
    checkroot
    checkargn 2
    shift
    burn "$1"
    ;;
  rebootneeded)
    checkargn 1
    rebootneeded
    ;;
  reboots)
    checkargn 3
    reboots "$2" "$3"
    ;;
  internet)
    checkargn 1
    internet
    ;;
  services)
    checkargn 4
    shift
    services "$@"
    ;;
  tor)
    checkroot
    checkargn 4
    shift
    tor "$@"
    ;;
  bootoption)
    checkrpi
    checkroot
    checkargn 3
    shift
    bootoption "$*"
    ;;
  openvpn)
    checkroot
    checkargn 4
    shift
    openvpn "$@"
    ;;
  coralenv)
    checkrpi
    checkroot
    checkargn 2
    shift
    coralenv "$@"
    ;;
  memory)
    checkargn 3
    shift
    memory "$@"
    ;;
  temperature)
    checkrpi
    checkargn 2
    temperature "$2"
    ;;
  speedtest)
    shift
    speedtest "$@"
    ;;
  camera)
    checkrpi
    checkargn 2
    camera "$2"
    ;;
  cron)
    checkroot
    checkargn 3
    cron "$2" "$3"
    ;;
  usb)
    checkroot
    checkargn 2
    usb "$2"
    ;;
  remote)
    checkroot
    checkrpi
    checkargn 3
    remote "$2" "$3"
    ;;
  log)
    checkroot
    checkargn 3
    log "$2" "$3"
    ;;
  blocker)
    checkroot
    checkargn 2
    blocker "$2"
    ;;
  help)
    checkargn 2
    help "$2"
    ;;
  *)
    help
    ;;
esac
if [ $? -eq 0 ]; then
  logit "$SCRIPTARGS" "1"
fi
