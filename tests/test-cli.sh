#!/bin/bash
# These tests are designed to be used
# with a RPi that is using its ethernet port
# If the networkmode is Wifi
# a lot of the tests will be skipped
# for wireless testing
export nssidname='YOUR-WIFI-NAME'
export nwifipass='YOUR-WIFI-PASS'

case "$1" in
  all)
    time bats ./*.bats ./*/*.bats
  ;;
  services)
    time bats ./services* ./services/*
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
         ./detectrpi.bats ./expandfs* ./h* ./image* ./l* ./m* ./n* \
         ./p* ./r* ./temperature* ./timezone* ./usb.bats ./verbose* ./version*
  ;;
  *)
    echo "Only 'all', 'services', 'wifi', 'ap', 'noninternet' options are supported"
    exit 1
  ;;
esac
