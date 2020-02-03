# @treehouses/cli

[![Build Status](https://travis-ci.org/treehouses/cli.svg?branch=master)](https://travis-ci.org/treehouses/cli)
[![npm version](https://badge.fury.io/js/%40treehouses%2Fcli.svg)](https://www.npmjs.com/package/%40treehouses%2Fcli)
[![npm](https://img.shields.io/npm/dw/@treehouses/cli)](https://www.npmjs.com/package/%40treehouses%2Fcli)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/treehouses/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## About

@treehouses/cli is a command-line interface for Raspberry Pi that is used to manage various services and functions.
Including vnc, ssh, tor, vpn, networking, starting services, bluetooth, led lights, and much more!
Also [treehouses remote](https://github.com/treehouses/remote) uses this interface. 

## Install

@treehouses/cli comes pre-installed on the treehouses image made with [builder](https://github.com/treehouses/builder).
To manually install on a Pi:
```bash
sudo curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install -y nodejs
sudo npm i -g --unsafe-perm @treehouses/cli
```
If you run into any problems check if your RPi is supported [here](https://github.com/treehouses/cli/blob/836c2e9b0bcebfe6afc97706634e7c070d795eac/modules/detectrpi.sh#L5-L42).

## Features

```
Usage: treehouses [command] ...


Commands:

help [command]                            gives you a more detailed info about the command or will output this
verbose <on|off>                          makes each command print more output (might not work with treehouses remote)
expandfs                                  expands the partition of the RPI image to the maximum of the SDcard
rename <hostname>                         changes hostname
password <password>                       changes the password for 'pi' user
sshkey <add|list|delete|deleteall|github> used for adding or removing ssh keys for authentication
version                                   returns the version of cli.sh command
image                                     returns version of the system image installed
detectrpi                                 detects the hardware version of a raspberry pi
detect                                    detects the hardware version of any device
ethernet <ip> <mask> <gateway> <dns>      configures rpi network interface to a static ip address
discover <scan|interface|ping|ports|mac>  performs network scan and discovers all raspberry pis on the network
         <rpi> [ipaddress|url|macaddress]
wifi <ESSID> [password]                   connects to a wifi network
wifihidden <ESSID> [password]             connects to a hidden wifi network
staticwifi <ip> <mask> <gateway> <dns>    configures rpi wifi interface to a static ip address
           <ESSID> [password]
wifistatus                                displays signal strength in dBm and layman nomenclature
bridge <ESSID> <hotspotESSID>             configures the rpi to bridge the wlan interface over a hotspot
       [password] [hotspotPassword]
container <none|docker|balena>            enables (and start) the desired container
bluetooth <on|off|pause|mac|id> [number]  switches bluetooth from regular to hotspot mode and shows id or MAC address
ap <local|internet> <ESSID> [password]    creates a mobile ap, which has two modes: local (no eth0 bridging), internet (eth0 bridging)
aphidden <local|internet> <ESSID>         creates a hidden mobile ap with or without internet access
         [password]
apchannel [channel]                       sets or prints the current ap channel
timezone <timezone>                       sets the timezone of the system
locale <locale>                           sets the system locale
ssh <on|off>                              enables or disables the ssh service
vnc [on|off|info]                         enables or disables the vnc server service
default                                   sets a raspbian back to default configuration
wificountry <country>                     sets the wifi country
upgrade                                   upgrades cli.sh package using npm
sshtunnel <add|remove|list|check|notice>  helps adding an sshtunnel
          <key|portinterval> [user@host]
led [green|red] [mode]                    sets the led mode
rtc <on|off> [rasclock|ds3231]            sets up the rtc clock specified
ntp <local|internet>                      sets rpi to host timing locally or to get timing from a remote server
networkmode                               outputs the current network mode
button <off|bluetooth>                    gives the gpio pin 18 an action
feedback <message>                        sends feedback
clone [device path]                       clones the current SDCard onto a secondary SDCard or specified device
restore [device path]                     restores a treehouses image to an SDCard or specified device
burn [device path]                        download and burns the latest treehouses image to the SDcard or specified device
rebootneeded                              shows if reboot is required to apply changes
reboots <now|in|cron>                     reboots at given frequency | removes it if reboot task active
        <daily|weekly|monthly>
internet                                  checks if the rpi has access to internet
services [service_name] [command]         executes the given command on the specified service
tor [list|add|delete|deleteall|start]     deals with services on tor hidden network
    [stop|destroy|notice|status|refresh]
bootoption <console|desktop> [autologin]  sets the boot mode
openvpn [use|show|delete]                 helps setting up an openvpn client
        [notice|start|stop|load]
coralenv [install|demo-on|demo-off]       plays with the coral environmental board
         [demo-always-on]
memory [total|used|free]                  displays the total memory of the device, the memory used as well as the available free memory 
temperature [celsius|fahrenheit]          displays raspberry pi's CPU temperature
speedtest                                 tests internet download and upload speed
camera [on|off|capture]                   enables camera, disables camera, captures png photo
cron [list|add|delete|deleteall]          adds, deletes a custom cron job or deletes, lists all cron jobs
     [0W|tor|timestamp]                   adds premade cron job (or removes it if already active)
usb [on|off]                              turns usb ports on or off
remote [status|upgrade|services]          helps with treehouses remote android app
log <0|1|2|3|4|show|max>                  gets/sets log level and shows log
```
