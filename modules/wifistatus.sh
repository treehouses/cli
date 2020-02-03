#!/bin/bash

function wifistatus {
  # layman nomenclature for wifi signal strength
  #   perfect=(-10 ... -29)
  #   incredible=(-30 -31 -32 -33 -34 -35 -36 -37 -38 -39)
  #   excellent=(-40 -41 -42 -43 -44 -45 -46 -47 -48 -49)
  #   good=(-50 -51 -52 -53 -54 -55 -56 -57 -58 -59)
  #   okay=(-60 -61 -62 -63 -64 -65 -66 -67 -68 -69)
  #   poor=(-70 -71 -72 -73 -74 -75 -76 -77 -78 -79)
  #   bad=(-80 -81 -82 -83 -84 -85 -86 -87 -88 -89 -90)
  # display strength of signal in dBm and layman terms
  signal=$(iwconfig wlan0 | sed -n 's/.*\(Signal level=-.*\)/\1/p' | sed -e 's/Signal level=//g' | sed -e 's/dBm//g')
  signalStrength=$(iwconfig wlan0 | sed -n 's/.*\(Signal level=-.*\)/\1/p' | sed -e 's/Signal level=//g')

  case "$1" in
    "")
      #check if device has wifi
      if iwconfig wlan0 2>&1 | grep -q "No such device"; then
        echo "Error: no wifi device is present"
        exit 0
      fi
      #check if device is connected to wifi
      if iwconfig wlan0 | grep -q "ESSID:off/any"; then
        echo "Error: you are not on a wireless connection"
      else
        echo "Signal strength is $signalStrength"
        if [ "$signal" -gt -30 ] && [ "$signal" -lt -10 ] ; then
          echo "You have a perfect signal"
        fi
        if [ "$signal" -gt -40 ] && [ "$signal" -lt -29 ] ; then
          echo "You have an incredible signal"
        fi
        if [ "$signal" -gt -50 ] && [ "$signal" -lt -39 ] ; then
          echo "You have an excellent signal"
        fi
        if [ "$signal" -gt -60 ] && [ "$signal" -lt -49 ] ; then
          echo "You have a good signal"
        fi
        if [ "$signal" -gt -70 ] && [ "$signal" -lt -59 ] ; then
          echo "You have an okay signal"
        fi
        if [ "$signal" -gt -80 ] && [ "$signal" -lt -69 ] ; then
          echo "You have a poor signal"
        fi
        if [ "$signal" -gt -90 ] && [ "$signal" -lt -79 ] ; then
          echo "You have a bad signal"
        fi
      fi
      ;;
    "simple")
      if [ "$signal" -gt -30 ] && [ "$signal" -lt -10 ] ; then
        echo "You have a perfect signal"
      fi
      if [ "$signal" -gt -40 ] && [ "$signal" -lt -29 ] ; then
        echo "You have an incredible signal"
      fi
      if [ "$signal" -gt -50 ] && [ "$signal" -lt -39 ] ; then
        echo "You have an excellent signal"
      fi
      if [ "$signal" -gt -60 ] && [ "$signal" -lt -49 ] ; then
        echo "You have a good signal"
      fi
      if [ "$signal" -gt -70 ] && [ "$signal" -lt -59 ] ; then
        echo "You have an okay signal"
      fi
      if [ "$signal" -gt -80 ] && [ "$signal" -lt -69 ] ; then
        echo "You have a poor signal"
      fi
      if [ "$signal" -gt -90 ] && [ "$signal" -lt -79 ] ; then
        echo "You have a bad signal"
      fi
      ;;
    "dbm")
      echo "$signal"
      ;;
    "*")
      wifistatus_help
      ;;
  esac
}

function wifistatus_help {
  echo
  echo "  Usage: $BASENAME wifistatus"
  echo
  echo "  Displays signal strength in dBm and layman nomenclature"
  echo
  echo "  Example:"
  echo "  $BASENAME wifistatus"
  echo "    Error: no wifi device is present"
  echo
  echo "  $BASENAME wifistatus"
  echo "    Signal strength is -40dBm"
  echo "    You have a perfect signal"
  echo
}
