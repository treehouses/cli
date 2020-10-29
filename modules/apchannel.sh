function apchannel {
  local new_channel current_channel
  checkrpi
  checkargn $# 1
  new_channel="$1"
  if [ "$(networkmode)" == "bridge" ] || [[ "$(networkmode)" == *"ap local"* ]] || [[ "$(networkmode)" == *"ap internet"* ]]; then
    current_channel=$(sed -n 's/channel=\(.*\)/\1/p' /etc/hostapd/hostapd.conf )
  else
    log_and_exit1 "Error: the current network mode ($(networkmode)) has no config for channel"
    
  fi

  if [ -z "$new_channel" ]; then
      echo $current_channel;
      exit 0
  fi

  checkroot

  if [ "$(echo "$new_channel" | grep -E '^([1-9]|11)$')" == "" ]; then
    log_and_exit1 "Error: you must specify a channel between 1 and 11"
  fi

  sed -i "s/channel=$current_channel/channel=$new_channel/g" /etc/hostapd/hostapd.conf
  restart_service hostapd
  reboot_needed
  echo "Success: the channel has been set to '$new_channel'. Please reboot to apply the changes"
}

function apchannel_help {
  echo
  echo "Usage: $BASENAME apchannel [channel]"
  echo
  echo "Prints out or sets the ap channel."
  echo
  echo "Example:"
  echo "  $BASENAME apchannel"
  echo "      This will print out the current ap channel"
  echo
  echo "  $BASENAME apchannel 6"
  echo "      This will set the ap channel to 6."
  echo "      A reboot is required to apply the changes."
  echo
}
