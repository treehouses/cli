#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"

for f in $SCRIPTFOLDER/modules/*.sh
do
  source "$f"
  cmd=$(basename "$f")
  cmd=${cmd%%.*}
  if [ "$cmd" = "$1" ] && [ "$1" != "globals" ] && [ "$1" != "config" ]; then
    find=1
  fi
done
if [ "$find" = 1 ]; then
  eval "$@"
else
  help
fi

<<<<<<< HEAD
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
  sdcard)
    checkroot
    shift
    case "${1}" in
      'downloadandburn'  ) download_and_burn "$2";;
      'erase'            ) erase_sd "$2";;
      *                  ) help ;; 
    esac 
    ;;
  help)
    help "$2"
    ;;
  *)
    help
    ;;
esac
=======
if [ $? -eq 0 ]; then
  logit "$SCRIPTARGS" "1"
fi
>>>>>>> 98401c537b45eba234331ad0ba1dee6f72daa785
