#!/bin/bash


function help_default {
  echo "Usage: $(basename "$0")"
  echo
  echo "   help [command]                            gives you a more detailed info about the command or will output this"
  echo "   expandfs                                  expands the partition of the RPI image to the maximum of the SDcard"
  echo "   rename <hostname>                         changes hostname"
  echo "   password <password>                       changes the password for 'pi' user"
  echo "   sshkey <add|list|delete|deleteall>        used for adding or removing ssh keys for authentication"
  echo "          <addgithubusername|addgithubgroup>"
  echo "   version                                   returns the version of $(basename "$0") command"
  echo "   image                                     returns version of the system image installed"
  echo "   detectrpi                                 detects the hardware version of a raspberry pi"
  echo "   detect                                    detects the hardware version of any device"
  echo "   ethernet <ip> <mask> <gateway> <dns>      configures rpi network interface to a static ip address"
  echo "   wifi <ESSID> [password]                   connects to a wifi network"
  echo "   staticwifi <ip> <mask> <gateway> <dns>    configures rpi wifi interface to a static ip address"
  echo "              <ESSID> [password]"
  echo "   bridge <ESSID> <hotspotESSID>             configures the rpi to bridge the wlan interface over a hotspot"
  echo "          [password] [hotspotPassword]"
  echo "   container <none|docker|balena>            enables (and start) the desired container"
  echo "   bluetooth <on|off>                        switches between bluetooth hotspot mode / regular bluetooth and starts the service"
  echo "   ap <local|internet> <ESSID> [password]    creates a mobile ap, which has two modes: local (no eth0 bridging), internet (eth0 bridging)"
  echo "   apchannel [channel]                       sets or prints the current ap channel"
  echo "   timezone <timezone>                       sets the timezone of the system"
  echo "   locale <locale>                           sets the system locale"
  echo "   ssh <on|off>                              enables or disables the ssh service"
  echo "   vnc [on|off|info]                         enables or disables the vnc server service"
  echo "   default                                   sets a raspbian back to default configuration"
  echo "   wificountry <country>                     sets the wifi country"
  echo "   upgrade                                   upgrades $(basename "$0") package using npm"
  echo "   sshtunnel <add|remove|list|check|notice>  helps adding an sshtunnel"
  echo "             <key|portinterval> [user@host]"
  echo "   led [green|red] [mode]                    sets the led mode"
  echo "   rtc <on|off> [rasclock|ds3231]            sets up the rtc clock specified"
  echo "   ntp <local|internet>                      enables or disables time through ntp servers"
  echo "   networkmode                               outputs the current network mode"
  echo "   button <off|bluetooth>                    gives the gpio pin 18 an action"
  echo "   feedback <message>                        sends feedback"
  echo "   clone [device path]                       clones the current SDCard onto a secondary SDCard or specified device"
  echo "   restore [device path]                     restores a treehouses image to an SDCard or specified device"
  echo "   burn [device path]                        download and burns the latest treehouses image to the SDcard or specified device"
  echo "   rebootneeded                              shows if reboot is required to apply changes"
  echo "   internet                                  checks if the rpi has access to internet"
  echo "   services [service_name] [format]          outputs or install the desired service"
  echo "            [install]"
  echo "   tor [start|stop|add|delete|list]          deals with services on tor hidden network"
  echo "       [notice|destroy|deleteall]"
  echo "   bootoption <console|desktop> [autologin]  sets the boot mode"
  echo "   openvpn [use|show|delete]                 helps setting up an openvpn client"
  echo "           [notice|start|stop|load]"
  echo "   coralenv [install|demo-on|demo-off]       plays with the coral environmental board"
  echo "            [demo-always-on]"
  echo "   memory [total|used|free]                  displays the total memory of the device, the memory used as well as the available free memory"
  echo "   temperature [celsius]                     displays raspberry pi's CPU temperature"
  echo "   cron [add|list|delete|deleteall]          execute scheduled commands"          
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
