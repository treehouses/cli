#!/bin/bash

function help_default {
  echo "Usage: $BASENAME"
  echo
  echo "   help [command]                            gives you a more detailed info about the command or will output this"
  echo "   verbose <on|off>                          makes each command print more output (might not work with treehouses remote)"
  echo "   expandfs                                  expands the partition of the RPI image to the maximum of the SDcard"
  echo "   rename <hostname>                         changes hostname"
  echo "   password <password>                       changes the password for 'pi' user"
  echo "   sshkey <add|list|delete|deleteall|github> used for adding or removing ssh keys for authentication"        
  echo "   version                                   returns the version of $BASENAME command"
  echo "   image                                     returns version of the system image installed"
  echo "   detectrpi                                 detects the hardware version of a raspberry pi"
  echo "   detect                                    detects the hardware version of any device"
  echo "   ethernet <ip> <mask> <gateway> <dns>      configures rpi network interface to a static ip address"
  echo "   discover <scan|interface|ping|ports|mac>  performs network scan and discovers all raspberry pis on the network"
  echo "            <rpi> [ipaddress|url|macaddress]"
  echo "   wifi <ESSID> [password]                   connects to a wifi network"
  echo "   wifihidden <ESSID> [password]             connects to a hidden wifi network"
  echo "   staticwifi <ip> <mask> <gateway> <dns>    configures rpi wifi interface to a static ip address"
  echo "              <ESSID> [password]"
  echo "   wifistatus                                displays signal strength in dBm and layman nomenclature"
  echo "   bridge <ESSID> <hotspotESSID>             configures the rpi to bridge the wlan interface over a hotspot"
  echo "          [password] [hotspotPassword]"
  echo "   container <none|docker|balena>            enables (and start) the desired container"
  echo "   bluetooth <on|off|pause|mac|id> [number]  switches bluetooth from regular to hotspot mode and shows id or MAC address"
  echo "   ap <local|internet> <ESSID> [password]    creates a mobile ap, which has two modes: local (no eth0 bridging), internet (eth0 bridging)"
  echo "   aphidden <local|internet> <ESSID>         creates a hidden mobile ap, with or without internet access"
  echo "            [password]" 
  echo "   apchannel [channel]                       sets or prints the current ap channel"
  echo "   timezone <timezone>                       sets the timezone of the system"
  echo "   locale <locale>                           sets the system locale"
  echo "   ssh <on|off>                              enables or disables the ssh service"
  echo "   vnc [on|off|info]                         enables or disables the vnc server service"
  echo "   default                                   sets a raspbian back to default configuration"
  echo "   wificountry <country>                     sets the wifi country"
  echo "   upgrade                                   upgrades $BASENAME package using npm"
  echo "   sshtunnel <add|remove|list|check|notice>  helps adding an sshtunnel"
  echo "             <key|portinterval> [user@host]"
  echo "   led [green|red] [mode]                    sets the led mode"
  echo "   rtc <on|off> [rasclock|ds3231]            sets up the rtc clock specified"
  echo "   ntp <local|internet>                      sets rpi to host timing locally or to get timing from a remote server"
  echo "   networkmode                               outputs the current network mode"
  echo "   button <off|bluetooth>                    gives the gpio pin 18 an action"
  echo "   feedback <message>                        sends feedback"
  echo "   clone [device path]                       clones the current SDCard onto a secondary SDCard or specified device"
  echo "   restore [device path]                     restores a treehouses image to an SDCard or specified device"
  echo "   burn [device path]                        download and burns the latest treehouses image to the SDcard or specified device"
  echo "   rebootneeded                              shows if reboot is required to apply changes"
  echo "   reboots <now|in|cron>                     reboots at given frequency | removes it if reboot task active"
  echo "           <daily|weekly|monthly>"
  echo "   internet                                  checks if the rpi has access to internet"
  echo "   services [service_name] [command]         executes the given command on the specified service"
  echo "   tor [list|add|delete|deleteall|start]     deals with services on tor hidden network"
  echo "       [stop|destroy|notice|status|refresh]"
  echo "   bootoption <console|desktop> [autologin]  sets the boot mode"
  echo "   openvpn [use|show|delete]                 helps setting up an openvpn client"
  echo "           [notice|start|stop|load]"
  echo "   coralenv [install|demo-on|demo-off]       plays with the coral environmental board"
  echo "            [demo-always-on]"
  echo "   memory [total|used|free]                  displays the total memory of the device, the memory used as well as the available free memory"
  echo "   temperature [celsius|fahrenheit]          displays raspberry pi's CPU temperature"
  echo "   speedtest                                 tests internet download and upload speed"
  echo "   camera [on|off|capture]                   enables camera, disables camera, captures png photo"
  echo "   cron [list|add|delete|deleteall]          adds, deletes a custom cron job or deletes, lists all cron jobs"
  echo "        [0W|tor|timestamp]                   adds premade cron job (or removes it if already active)"
  echo "   usb [on|off]                              turns usb ports on or off"
  echo "   remote [status|upgrade|services]          helps with treehouses remote android app"
  echo "   log <0|1|2|3|4|show|max>                  gets/sets log level and shows log"
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
