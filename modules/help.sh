function help_default {
  helpdefault=""
  read -r -d '' helpdefault <<'EOF'
Usage: treehouses [command] ...


Commands:

help [command]                            gives you a more detailed info about the command or will output this
verbose <on|off>                          makes each command print more output (might not work with treehouses remote)
expandfs                                  expands the partition of the RPI image to the maximum of the SD card
rename <hostname>                         changes hostname
password <disable|enable|change [passwd]> changes the password for 'pi' user or disables/enables password authentication
sshkey <add|list|delete|deleteall|github> used for adding or removing ssh keys for authentication
version [contributors|remote]             returns the version of treehouses CLI, remote, or list of contributors
image                                     returns version of the system image installed
detect [bluetooth|rpi|arm|arch|wifi]      detects the hardware version of any device
ethernet <ip> <mask> <gateway> <dns>      configures rpi network interface to a static ip address
discover <scan|interface|ping|ports|mac>  performs network scan and discovers all raspberry pis on the network
         <rpi> [ipaddress|url|macaddress]
         <wifi|self> <gateway> [list]
wifi <ESSID> [password] [identity]        connects to a wifi network
wifihidden <ESSID> [password] [identity]  connects to a hidden wifi network
tether                                    enable usb0 interface tethering
staticwifi <ip> <mask> <gateway> <dns>    configures rpi wifi interface to a static ip address
           <ESSID> [password]
wifistatus                                displays signal strength in dBm and layman nomenclature
bridge <ESSID> <hotspotESSID>             configures the rpi to bridge the wlan interface over a hotspot
       [password] [hotspotPassword]
dhcp [list|status]                        displays dhcp status and devices
config [update|add|delete|clear]          commands for interacting with config file
container <none|docker|balena>            enables (and start) the desired container
bluetooth [on|off|pause|restart|button]   switches bluetooth from regular to hotspot mode and shows id or MAC address
          [mac|id|status|log]
ap <local|internet> <ESSID> [password]    creates a mobile ap, which has two modes: local (no eth0 bridging), internet (eth0 bridging)
aphidden <local|internet> <ESSID>         creates a hidden mobile ap with or without internet access
         [password]
apchannel [channel]                       sets or prints the current ap channel
timezone <timezone>                       sets the timezone of the system
locale <locale>                           sets the system locale
ssh [on|off|fingerprint]                  enables or disables the ssh service,
    [2fa] <add|remove|enable|disable>     prints out fingerprint of the ssh daemon
          <show|list>                     and deals with two factor authentication
vnc [on|off|info|auth|password]           enables or disables the vnc server service
default [network|notice|tunnel]           sets a raspbian back to default configuration
wificountry <country>                     sets the wifi country
upgrade [tag|check|bluetooth|force|cli]   upgrades treehouses package using npm
sshtunnel [add|remove|list|active|check]  helps adding sshtunnels
          [key|refresh|notice|ports]
led [green|red] [mode]                    sets the led mode
    [newyear|blackhistorymonth]
    [lunarnewyear|valentine|carnival]
    [lantern|stpatricks|easter|labourday]
    [eid|dragonboat|independenceday|onam]
    [diwali|thanksgiving|christmas]
    [heavymetal|dance|kecak|sandstorm]
    [random]
power [mode|current|freq|status]          sets the power mode or check power mode/CPU frequency
uptime [boot|start|stop|log]              displays uptime and boot time of the Raspberry Pi
rtc <on|off> [rasclock|ds3231]            sets up the rtc clock specified
ntp <local|internet>                      sets rpi to host timing locally or to get timing from a remote server
networkmode                               outputs the current network mode
button <off|bluetooth>                    gives the gpio pin 18 an action
feedback <message>                        sends feedback
clone [detect| device path]               clones the current SD card onto a secondary SD card or specified device
restore [device path]                     restores a treehouses image to an SD card or specified device
burn [device path]                        download and burns the latest treehouses image to the SD card or specified device
rebootneeded                              shows if reboot is required to apply changes
reboots <now|in|cron>                     reboots at given frequency | removes it if reboot task active
        <daily|weekly|monthly>
internet [reverse]                        checks if the rpi has access to internet
services                                  executes the given command on the specified service
   <available|installed [full]>           list available, and installed services
   <ports|running [full]>                 list ports used by services and services running
   [planet]       <install>               Planet Learning is a generic learning system built in Angular & CouchDB
   [kolibri]      <up>                    Kolibri is a learning platform using DJango
   [nextcloud]    <start>                 Nextcloud is a safe home for all your data, files, etc
   [netdata]      <restart>               Netdata is a distributed, real-time performance and health monitoring for systems
   [mastodon]     <stop>                  Mastodon is a free, open-source social network server
   [moodle]       <down>                  Moodle is a learning management system built in PHP
   [pihole]       <cleanup>               Pi-hole is a DNS sinkhole that protects your devices from unwanted content
   [privatebin]   <autorun [true|false]>  PrivateBin is a minimalist, open source online pastebin
   [portainer]    <url [local|tor]>       Portainer is a lightweight management UI for Docker environments
   [ntopng]       <info>                  Ntopng is a network traffic probe that monitors network usage
   [couchdb]      <size>                  CouchDB is an open-source document-oriented NoSQL database, implemented in Erlang
   [mariadb]      <icon>                  MariaDB is a community-developed fork of the MySQL relational database management system
   [mongodb]      <port|ps>               MongoDB is a general purpose, distributed, document-based, NoSQL database
   [seafile]      <config>                Seafile is an open-source, cross-platform file-hosting software system
   [librespeed]                           Librespeed is a very lightweight Speedtest implemented in Javascript
   [turtleblocksjs]                       TurtleBlocks is an activity with a Logo-inspired graphical "turtle" that draws colorful art
   [musicblocks]                          MusicBlocks is a programming language for exploring musical concepts in an fun way
   [minetest]                             Minetest is an open source infinite-world block sandbox game engine with survival and crafting
   [invoiceninja]                         Invoiceninja is the leading self-host platform to create invoices
   [grocy]                                Grocy is a web-based, self-hosted groceries and household management utility for your home
   [dokuwiki]                             Dokuwiki is a simple to use and highly versatile Open Source wiki software
   [bookstack]                            Bookstack is a free and open source Wiki designed for creating beautiful documentation
   [transmission]                         Transmission is a BitTorrent client with many powerful features
   [piwigo]                               Piwigo is a photo gallery software to publish and manage your collection of pictures
   [cloud9]                               Cloud9 is a complete web based ide with terminal access
   [jellyfin]                             Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media
   [pylon]                                Pylon is a web based integrated development environment built with Node.js as a backend
   [rutorrent]                            Rutorrent is a popular rtorrent client with a webui for ease of use
   [webssh]                               Webssh is a simple web application to be used as an ssh client to connect to your ssh servers
   [sysmon]                               Sysmon is an intuitive system performance monitoring and task management tool for servers
   [epaath]                               Epaath is an interactive educational activity
tor [list|ports|add|delete|deleteall]     deals with services on tor hidden network
    [start|stop|destroy|notice]
    [status|refresh]
bootoption <console|desktop> [autologin]  sets the boot mode
           <modules|params>
openvpn [use|show|delete]                 helps setting up an openvpn client
        [notice|start|stop|load]
shadowsocks [list|add|enable|start]       manage shadowsocks, a socks5 proxy designed
            [enter|disable|stop|remove]   to "protect" your Internet traffic
coralenv [install|demo-on|demo-off]       plays with the coral environmental board
         [demo-always-on]
memory [total|used|free] [gb|mb]          displays the total memory of the device, the memory used as well as the available free memory
storage [total|used|free] [gb|mb|kb]      displays the total storage of the device, the storage used as well as the available free storage
temperature [celsius|fahrenheit|kelvin]   displays raspberry pi's CPU temperature
speedtest                                 tests internet download and upload speed
camera [on|off|detect|capture|record]     enables and disables camera, detects camera module version, captures photo, records video
picture [file|url]                        displays a picture in the terminal
cron [list|add|delete|deleteall]          adds, deletes a custom cron job or deletes, lists all cron jobs
     [0W|tor|timestamp]                   adds premade cron job (or removes it if already active)
usb [on|off]                              turns usb ports on or off
redirect [add|list|remove|start]          redirects internet hostnames to rpi
remote <check|status|upgrade|services>    helps with treehouses remote android app
       <version|commands|reverse>
       <allservices|statuspage|ssh2fa>
       <help|key>
log <0|1|2|3|4|show|max>                  gets/sets log level and shows log
blocker <0|1|2|3|4||max>                  website blocking levels using /etc/hosts
sdbench                                   displays read and write speed of micro SD card
inspire [fact|joke|qotd|random]           displays quote based on user input
convert <input file> <output file>        converts video and audio files
gpio                                      displays raspberry pi model and corresponding GPIO ports
changelog [view|compare]                  displays the most recent changes to treehouses
magazines                                 downloads specific magazine issue as a pdf based on user input
   <available|downloaded>                 lists the available magazine types, lists downloaded magazines in a tree format
   <helloworld>       [all]               downloads all issues of magazine
   <hackspace>        [latest]            downloads latest issue of magazine
   <magpi>            [number]            downloads issue [number] of magazine
   <wireframe>        [list]              lists downloaded magazines in tree format of specific magazine
                      [url]               shows the homepage URL of magazine
resolution <cea|dmt [modes]>              sets the screen resolution depending on the attached display device
system [cpu|ram|disk|volt|temperature]    display real system informations
message                                   sends message to chat service
   <gitter>  <apitoken|authorize>         sets api/channel info in config file 
             <send|show|read|mark>        sends/recieves messages in gitter
             <channels>
   <slack>   <apitoken|channels>          sets api/channel info in config file 
             <send|show|read|mark>        sends/recieves messages in slack
   <discord> <apitoken|authorize>         sets api/channel info in config file
shutdown [now|in|force]                   shutdown the system
EOF
  echo "$helpdefault"
}

function help {
  checkargn $# 1
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
