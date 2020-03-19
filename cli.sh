#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"
SCRIPTARGNUM=$#

for f in $SCRIPTFOLDER/modules/*; do source "$f"; done
start_spinner
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
  detectbluetooth)
    checkargn 1
    detectbluetooth
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
    checkwrpi
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
    checkwrpi
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
  sdbench)
    checkroot
    sdbench
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
if [[ ! -v NOSPIN ]]; then
  tput cvvis
fi
