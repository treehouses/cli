# npm i @treehouses/cli

[![Build Status](https://travis-ci.org/treehouses/cli.svg?branch=master)](https://travis-ci.org/treehouses/cli)
[![npm version](https://badge.fury.io/js/%40treehouses%2Fcli.svg)](https://www.npmjs.com/package/%40treehouses%2Fcli)
[![npm](https://img.shields.io/npm/dw/@treehouses/cli)](https://www.npmjs.com/package/%40treehouses%2Fcli)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/treehouses/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

```
Usage: treehouses [command] ...

Commands:

help [command]                            gives you more detailed info about the command or will output this

bluetooth <on|off>                        switches between bluetooth hotspot mode / regular bluetooth and starts the service
bluetoothid [number]                      displays the bluetooth network name with the 4 random digits attached
bootoption <console|desktop> [autologin]  sets the boot mode
bridge <ESSID> <hotspotESSID>             configures the rpi to bridge the wlan interface over a hotspot
       [password] [hotspotPassword]
button <off|bluetooth>                    gives the gpio pin 18 an action
clone [device path]                       clones the current SDCard onto a secondary SDCard or specified device
default                                   sets a raspbian back to default configuration
detect                                    detects the hardware version of any device
detectrpi                                 detects the hardware version of a raspberry pi
ethernet <ip> <mask> <gateway> <dns>      configures rpi network interface to a static ip address
expandfs                                  expands the partition of the RPI image to the maximum of the SDcard
internet                                  checks if the rpi has access to internet
led [green|red] [mode]                    sets the led mode
locale <locale>                           sets the system locale
memory [total|used|free]                  displays the total memory of the device, the memory used as well as the available free memory
temperature [celsius]                     displays raspberry pi's CPU temperature
timezone <timezone>                       sets the timezone of the system

burn [device path]                        download and burns the latest treehouses image to the sdcard or specified device
container <none|docker|balena>            enables (and start) the desired container
coralenv [install|demo-on|demo-off]       plays with the coral environmental board
         [demo-always-on]
image                                     returns version of the system image installed
password <password>                       changes the password for 'pi' user
rebootneeded                              shows if reboot is required to apply changes
rename <hostname>                         changes hostname
restore [device path]                     restores a treehouses image to an SDCard or specified device
rtc <on|off> [rasclock|ds3231]            sets up the rtc clock specified
services [service_name] [format]          outputs or install the desired service
         [install]
upgrade                                   upgrades $(basename "$0") package using npm
version                                   returns the version of $(basename "$0") command

ap <local|internet> <ESSID> [password]    creates a mobile ap, which has two modes: local (no eth0 bridging), internet (eth0 bridging)
apchannel [channel]                       sets or prints the current ap channel
networkmode                               outputs the current network mode
ntp <local|internet>                      enables or disables time through ntp servers
openvpn [use|show|delete]                 helps setting up an openvpn client
        [notice|start|stop|load]
speedtest                                 tests internet download and upload speed
ssh <on|off>                              enables or disables the ssh service
sshkey <add|list|delete|deleteall>        used for adding or removing ssh keys for authentication
       <addgithubusername|addgithubgroup>
sshtunnel <add|remove|list|check|notice>  helps adding an sshtunnel
          <key|portinterval> [user@host]
staticwifi <ip> <mask> <gateway> <dns>    configures rpi wifi interface to a static ip address
           <ESSID> [password]
tor [start|stop|add|delete|list]          deals with services on tor hidden network
    [notice|destroy|deleteall]
vnc [on|off|info]                         enables or disables the vnc server service
wifi <ESSID> [password]                   connects to a wifi network
wificountry <country>                     sets the wifi country

feedback <message>                        sends feedback
```
