#!/bin/bash
# These tests are designed to be used
# with a RPi that is using its ethernet port
# If the networkmode is Wifi
# a lot of the tests will be skipped
# for wireless testing
export nssidname='YOUR-WIFI-NAME'
export nwifipass='YOUR-WIFI-PASS'

echo
echo "Branch  - $(git rev-parse --abbrev-ref HEAD)"
echo "Image   - $(../cli.sh image)"
echo "Version - $(../cli.sh version)"
echo
case "$1" in
  *.bats)
    time bats "$@"
  ;;
  all)
    time bats ./*.bats ./services/*.bats ./magazines/*.bats
  ;;
  services)
    time bats ./services*
  ;;
  magazine)
    time bats ./magazine*
  ;;
  wifi)
    time bats ./wifi*
  ;;
  ap)
    time bats ./ap*
  ;;
  nonet)
    time bats ./blocker* ./bluetooth* ./bootoption* ./burn* ./button* \
         ./c* ./detect* ./expandfs* ./h* ./image* ./l* ./m* ./n* \
         ./p* ./r* ./temperature* ./timezone* ./usb.bats ./verbose* ./version*
  ;;
  nonetblue)
    time bats ./blocker* ./bootoption* ./burn* ./c* ./detect.bats \
         ./expandfs* ./h* ./image* ./l* ./m* ./n* \
         ./p* ./r* ./temperature* ./timezone* ./usb.bats ./verbose* ./version*
  ;;
  *)
    echo "Only 'all', 'services', 'magazine', 'wifi', 'ap', 'nonet', 'nonetblue' options are supported"
    exit 1
  ;;
esac
echo
