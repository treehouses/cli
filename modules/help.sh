#!/bin/bash


function help_default {
  echo "Usage: $(basename "$0")"
  echo
  echo "   expandfs                                 expands the partition of the RPI image to the maximum of the SDcard"
  echo "   rename <hostname>                        changes hostname"
  echo "   password <password>                      changes the password for 'pi' user"
  echo "   sshkeyadd <public_key>                   adds a public key to 'pi' and 'root' user's authorized_keys"
  echo "   version                                  returns the version of $(basename "$0") command"
  echo "   image                                    returns version of the system image installed"
  echo "   detectrpi                                detects the hardware version of a raspberry pi"
  echo "   ethernet <ip> <mask> <gateway> <dns>     configures rpi network interface to a static ip address"
  echo "   wifi <ESSID> [password]                  connects to a wifi network"
  echo "   staticwifi <ip> <mask> <gateway> <dns>   configures rpi wifi interface to a static ip address"
  echo "              <ESSID> [password]"
  echo "   bridge <ESSID> <hotspotESSID>            configures the rpi to bridge the wlan interface over a hotspot"
  echo "          [password] [hotspotPassword]"
  echo "   container <none|docker|balena>           enables (and start) the desired container"
  echo "   bluetooth <on|off>                       switches between bluetooth hotspot mode / regular bluetooth and starts the service"
  echo "   hotspot <ESSID> [password]               creates a mobile hotspot. this command has been deprecated, please use treehouses ap"
  echo "   ap <local|internet> <ESSID> [password]   creates a mobile ap, which has two modes: local (no eth0 bridging), internet (eth0 bridging)"
  echo "   timezone <timezone>                      sets the timezone of the system"
  echo "   locale <locale>                          sets the system locale"
  echo "   ssh <on|off>                             enables or disables the ssh service"
  echo "   vnc <on|off>                             enables or disables the vnc server service"
  echo "   default                                  sets a raspbian back to default configuration"
  echo "   wificountry <country>                    sets the wifi country"
  echo "   upgrade                                  upgrades $(basename "$0") package using npm"
  echo "   sshtunnel <add|remove|show>              helps adding an sshtunnel"
  echo "             <portinterval> [user@host]"
  echo "   led [green|red] [mode]                   sets the led mode"
  echo "   rtc <on|off> [rasclock|ds3231]           sets up the rtc clock specified"
  echo "   ntp <local|internet>                     enables or disables time through ntp servers"
  echo "   networkmode                              outputs the current network mode"
  echo "   button <off|bluetooth>                   gives the gpio pin 18 an action"
  echo "   feedback <message>                       sends feedback"
  echo "   clone                                    clones the current SD onto a secondary SDcard"
  echo
}

function help {
  if [ -z "$1" ]; then
    help_default
  else
    if [ "$(type -t "$1_help")" = "function" ]; then
      "$1_help"
    else
      help_default
    fi
  fi
}
