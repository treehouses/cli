#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
CONFIGFOLDER=~/.treehouses/
CONFIGFILE="$CONFIGFOLDER"config
LOGFOLDER="$CONFIGFOLDER"logs/

source "$SCRIPTFOLDER/modules/log.sh"
source "$SCRIPTFOLDER/modules/detectrpi.sh"
source "$SCRIPTFOLDER/modules/globals.sh"
source "$SCRIPTFOLDER/modules/ap.sh"
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

LOGFILE=/dev/null
LOG=ON
if [[ ! -d "$CONFIGFOLDER" ]]; then
  mkdir "$CONFIGFOLDER"
fi
if [[ -s "$CONFIGFILE" ]]
then
  source "$CONFIGFILE"
else
  touch "$CONFIGFILE"
fi

case $1 in
  expandfs)
    checkrpi
    checkroot
	log_info "expandfs: execution started with $@ arguments"
    expandfs
    ;;
  rename)
    checkroot
	log_info "rename: execution started with $@ arguments"
    rename "$2"
    ;;
  password)
    checkrpi
    checkroot
	log_info "password: execution started with $@ arguments"
    password "$2"
    ;;
  sshkey)
    checkroot
	log_info "sshkey: execution started with $@ arguments"
    shift	
    sshkey "$@"
    ;;
  version)
    log_info "version: execution started with $@ arguments"
    version
    ;;
  image)
    log_info "image: execution started with $@ arguments"
    image
    ;;
  detect)
    log_info "detect: execution started with $@ arguments"
    detect
    ;;
  detectrpi)
    log_info "detectrpi: execution started with $@ arguments"
    detectrpi
    ;;
  wifi)
    checkrpi
    checkroot
	log_info "wifi: execution started with $@ arguments"
    wifi "$2" "$3"
    ;;
  wifihidden)
    checkrpi
    checkroot
	log_info "wifihidden: execution started with $@ arguments"
    wifihidden "$2" "$3"
    ;;
  staticwifi)
    checkrpi
    checkroot
	log_info "staticwifi: execution started with $@ arguments"
    staticwifi "$2" "$3" "$4" "$5" "$6" "$7"
    ;;
  container)
    checkroot
	log_info "container: execution started with $@ arguments"
    container "$2"
    ;;
  bluetooth)
    checkwrpi
    checkroot
	log_info "bluetooth: execution started with $@ arguments"
    bluetooth "$2" "$3"
    ;;
  bluetoothid)
    checkrpi
	log_info "bluetoothid: execution started with $@ arguments"
    bluetoothid "$2"
    ;;
  ethernet)
    checkrpi
    checkroot
	log_info "ethernet: execution started with $@ arguments"
    ethernet "$2" "$3" "$4" "$5"
    ;;
  ap)
    checkrpi
    checkroot
	log_info "ap: execution started with $@ arguments"
    shift
    ap "$@"
    ;;
  discover)
    log_info "discover: execution started with $@ arguments"
    shift
    discover "$@"
    ;;
  timezone)
    checkroot
	log_info "timezone: execution started with $@ arguments"
    timezone "$2"
    ;;
  locale)
    checkroot
	log_info "locale: execution started with $@ arguments"
    locale "$2"
    ;;
  ssh)
    checkroot
	log_info "ssh: execution started with $@ arguments"
    ssh "$2"
    ;;
  verbose)
    checkroot
	log_info "verbose: execution started with $@ arguments"
    verbose "$2"
    ;;
  vnc)
    checkroot
	log_info "vnc: execution started with $@ arguments"
    vnc "$2"
    ;;
  default)
    checkroot
	log_info "default: execution started with $@ arguments"
    default "$2"
    ;;
  upgrade)
    log_info "upgrade: execution started with $@ arguments"
    shift
    upgrade "$@"
    ;;
  bridge)
    checkrpi
    checkroot
	log_info "bridge: execution started with $@ arguments"
    shift
    bridge "$@"
    ;;
  wificountry)
    checkrpi
    checkroot
	log_info "wificountry: execution started with $@ arguments"
    wificountry "$2"
    ;;
  wifistatus)
    checkrpi
	log_info "wifistatus: execution started with $@ arguments"
    wifistatus "$2"
    ;;
  sshtunnel)
    checkroot
	log_info "sshtunnel: execution started with $@ arguments"
    sshtunnel "$2" "$3" "$4"
    ;;
  led)
    checkrpi
	log_info "led: execution started with $@ arguments"
    led "$2" "$3"
    ;;
  rtc)
    checkrpi
    checkroot
	log_info "rtc: execution started with $@ arguments"
    rtc "$2" "$3"
    ;;
  ntp)
    checkrpi
    checkroot
	log_info "ntp: execution started with $@ arguments"
    ntp "$2"
    ;;
  networkmode)
    log_info "networkmode: execution started with $@ arguments"
    networkmode "$2"
    ;;
  button)
    checkrpi
    checkroot
	log_info "button: execution started with $@ arguments"
    button "$2"
    ;;
  feedback)
    log_info "feedback: execution started with $@ arguments"
    shift
    feedback "$*"
    ;;
  apchannel)
    checkrpi
	log_info "apchannel: execution started with $@ arguments"
    shift
    apchannel "$1"
    ;;
  clone)
    checkrpi
    checkroot
	log_info "clone: execution started with $@ arguments"
    shift
    clone "$1"
    ;;
  restore)
    checkrpi
    checkroot
	log_info "restore: execution started with $@ arguments"
    shift
    restore "$1"
    ;;
  burn)
    checkrpi
    checkroot
	log_info "burn: execution started with $@ arguments"
    shift
    burn "$1"
    ;;
  rebootneeded)
    log_info "rebootneeded: execution started with $@ arguments"
    rebootneeded
    ;;
  reboots)
    log_info "reboots: execution started with $@ arguments"
    reboots "$2" "$3"
    ;;
  internet)
    log_info "internet: execution started with $@ arguments"
    internet
    ;;
  services)
    log_info "services: execution started with $@ arguments"
    shift
    services "$@"
    ;;
  tor)
    checkroot
	log_info "tor: execution started with $@ arguments"
    shift
    tor "$@"
    ;;
  bootoption)
    checkrpi
    checkroot
	log_info "bootoption: execution started with $@ arguments"
    shift
    bootoption "$*"
    ;;
  openvpn)
    checkroot
	log_info "openvpn: execution started with $@ arguments"
    shift
    openvpn "$@"
    ;;
  coralenv)
    checkrpi
    checkroot
	log_info "coralenv: execution started with $@ arguments"
    shift
    coralenv "$@"
    ;;
  memory)
    log_info "memory: execution started with $@ arguments"
    shift
    memory "$@"
    ;;
  temperature)
    checkrpi
	log_info "temperature: execution started with $@ arguments"
    temperature "$2"
    ;;
  speedtest)
    log_info "speedtest: execution started with $@ arguments"
    shift
    speedtest "$@"
    ;;
  camera)
    checkrpi
	log_info "camera: execution started with $@ arguments"
    camera "$2"
    ;;
  cron)
    checkroot
	log_info "cron: execution started with $@ arguments"
    cron "$2" "$3"
    ;;
  usb)
    checkroot
	log_info "usb: execution started with $@ arguments"
    usb "$2"
    ;;
  remote)
    checkroot
    checkrpi
	log_info "remote: execution started with $@ arguments"
    remote "$2" "$3"
    ;;
  log)
    checkroot
	log_info "log: execution started with $@ arguments"
    log "$2"
    ;;
  help)
    log_info "help: execution started with $@ arguments"
    help "$2"
    ;;
  *)
    log_info "*help: execution started with $@ arguments"
    help
    ;;
esac
