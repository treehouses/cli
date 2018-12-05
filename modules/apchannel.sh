#!/bin/bash

function apchannel {
  command="$1"
  if [ "$(networkmode)" == "bridge" ] || [ "$(networkmode)" == "ap local" ] || [ "$(networkmode)" == "ap internet" ]; then
    current_channel=$(cat /etc/hostapd/hostapd.conf | sed -n 's/channel=\(.*\)/\1/p')
  else
    echo "Error: the current network mode ($(networkmode)) has no config for channel"
    exit 1
  fi

  if [ "$command" == "set" ]; then
    checkroot

    new_channel="$2"
    if [ "$(echo "$new_channel" | grep -E '^([1-9]|11)$')" == "" ]; then
      echo "Error: you must specify a channel between 1 and 11"
      exit 1
    fi

    sed -i "s/channel=$current_channel/channel=$new_channel/g" /etc/hostapd/hostapd.conf
    restart_service hostapd
    echo "Success: the channel has been set to '$new_channel'. Please reboot to apply the changes"
  else
    if [ -z "$command" ]; then
      echo $current_channel;
    else
      echo "Error: the argument is not recognized. Only set is known."
    fi;
  fi
}

function apchannel_help {
  echo ""
  echo "Usage: $(basename "$0") apchannel [set] [channel]"
  echo ""
  echo "Prints out or sets the ap channel."
  echo ""
  echo "Example:"
  echo "  $(basename "$0") apchannel"
  echo "      This will print out the current ap channel"
  echo ""
  echo "  $(basename "$0") apchannel set 6"
  echo "      This will set the ap channel to 6."
  echo "      A reboot is required to apply the changes."
  echo ""
}