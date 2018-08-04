#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")

# shellcheck source=modules/globals.sh
source "$SCRIPTFOLDER/modules/globals.sh"
# shellcheck source=modules/bluetooth.sh
source "$SCRIPTFOLDER/modules/bluetooth.sh"
# shellcheck source=modules/bridge.sh
source "$SCRIPTFOLDER/modules/bridge.sh"
# shellcheck source=modules/container.sh
source "$SCRIPTFOLDER/modules/container.sh"
# shellcheck source=modules/default.sh
source "$SCRIPTFOLDER/modules/default.sh"
# shellcheck source=modules/detectrpi.sh
source "$SCRIPTFOLDER/modules/detectrpi.sh"
# shellcheck source=modules/ethernet.sh
source "$SCRIPTFOLDER/modules/ethernet.sh"
# shellcheck source=modules/expandfs.sh
source "$SCRIPTFOLDER/modules/expandfs.sh"
# shellcheck source=modules/help.sh
source "$SCRIPTFOLDER/modules/help.sh"
# shellcheck source=modules/hotspot.sh
source "$SCRIPTFOLDER/modules/hotspot.sh"
# shellcheck source=modules/image.sh
source "$SCRIPTFOLDER/modules/image.sh"
# shellcheck source=modules/led.sh
source "$SCRIPTFOLDER/modules/led.sh"
# shellcheck source=modules/locale.sh
source "$SCRIPTFOLDER/modules/locale.sh"
# shellcheck source=modules/password.sh
source "$SCRIPTFOLDER/modules/password.sh"
# shellcheck source=modules/rename.sh
source "$SCRIPTFOLDER/modules/rename.sh"
# shellcheck source=modules/ssh.sh
source "$SCRIPTFOLDER/modules/ssh.sh"
# shellcheck source=modules/sshkeyadd.sh
source "$SCRIPTFOLDER/modules/sshkeyadd.sh"
# shellcheck source=modules/sshtunnel.sh
source "$SCRIPTFOLDER/modules/sshtunnel.sh"
# shellcheck source=modules/staticwifi.sh
source "$SCRIPTFOLDER/modules/staticwifi.sh"
# shellcheck source=modules/timezone.sh
source "$SCRIPTFOLDER/modules/timezone.sh"
# shellcheck source=modules/upgrade.sh
source "$SCRIPTFOLDER/modules/upgrade.sh"
# shellcheck source=modules/version.sh
source "$SCRIPTFOLDER/modules/version.sh"
# shellcheck source=modules/vnc.sh
source "$SCRIPTFOLDER/modules/vnc.sh"
# shellcheck source=modules/wifi.sh
source "$SCRIPTFOLDER/modules/wifi.sh"
# shellcheck source=modules/wificountry.sh
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
  hotspot)
    checkroot
    hotspot "$2" "$3"
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
  help)
    help "$2"
    ;;
  *)
    help
    ;;
esac
