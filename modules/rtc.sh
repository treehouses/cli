#!/bin/bash

declare -A rtcclockdata
rtcclockdata["rasclock"]="dtoverlay=i2c-rtc,pcf2127"
rtcclockdata["ds3231"]="dtoverlay=i2c-rtc,ds3231"

function get_current_clock {
  for i in "${rtcclockdata[@]}"
  do
    if grep -q "$i" "/boot/config.txt" 2>"$LOGFILE"; then
      prevClock="$i"
      break
    fi
  done

  echo "$prevClock"
}

function write_rtc {
  clock="$1"

  prevClock=$(get_current_clock)

  if [ ! -z "$prevClock" ]; then
    sed -i -e "s/$prevClock/$clock/g" /boot/config.txt
  else
    echo "$clock" >> /boot/config.txt
  fi
}

function rtc {
  status="$1"
  clock="$2"

  if [ "$status" = "on" ]; then
    if [ -z "$clock" ]; then
      echo "Error: you need to specify a clock"
      exit 0
    elif [ -z "${rtcclockdata[$clock]}" ]; then
      echo "Error: the clock is not supported."
      exit 0
    else
      write_rtc "${rtcclockdata[$clock]}"

      if [ -f "/lib/udev/hwclock-set.old" ]; then
        cp /lib/udev/hwclock-set.old /lib/udev/hwclock-set
      else
        cp /lib/udev/hwclock-set /lib/udev/hwclock-set.old
      fi

      # https://i.imgur.com/aq0rLJl.png
      sed -e '/run\/systemd\/system/,+2 s/^#*/#/' -i /lib/udev/hwclock-set
      sed -e '/--systz/ s/^#*/#/' -i /lib/udev/hwclock-set

      apt-get --force-yes -y remove fake-hwclock -qq &> "$LOGFILE"
      update-rc.d -f fake-hwclock remove &> "$LOGFILE"

      reboot_needed
      echo "Success: clock changed. Please reboot"
    fi
  elif [ "$status" = "off" ]; then
    currentClock=$(get_current_clock)
    if [ ! -z "$currentClock" ]; then
      sed -i "s/$currentClock//" /boot/config.txt
    fi;

    cp /lib/udev/hwclock-set.old /lib/udev/hwclock-set

    apt-get -y install fake-hwclock -qq &> "$LOGFILE"
    update-rc.d -f fake-hwclock defaults &> "$LOGFILE"

    reboot_needed
    echo "Success: clock changed. Please reboot"
  else
    echo "Error: only on, off options are supported"
    exit 0
  fi
}

function rtc_help {
  echo
  echo "Usage: $BASENAME rtc <on|off> [ds3231|rasclock]"
  echo
  echo "Enables or disables the rtc clock"
  echo
  echo "Example:"
  echo "  $BASENAME rtc off"
  echo "      Disables the rtc clock."
  echo
  echo "  $BASENAME rtc on rasclock"
  echo "      Set ups the system to make the 'rasclock' clock work."
  echo
  echo "  $BASENAME rtc on ds3231"
  echo "      Set ups the system to make the 'ds3231' clock work."
  echo
}