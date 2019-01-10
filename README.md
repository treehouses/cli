# Usage

```
Usage: treehouses [command] ...


Commands:

help [command]                           gives you a more detailed info about the command or will output this
expandfs                                 expands the partition of the RPI image to the maximum of the SDcard
rename <hostname>                        changes hostname
password <password>                      changes the password for 'pi' user
sshkeyadd <public_key>                   adds a public key to 'pi' and 'root' user's authorized_keys
version                                  returns the version of cli.sh command
image                                    returns version of the system image installed
detectrpi                                detects the hardware version of a raspberry pi
ethernet <ip> <mask> <gateway> <dns>     configures rpi network interface to a static ip address
wifi <ESSID> [password]                  connects to a wifi network
staticwifi <ip> <mask> <gateway> <dns>   configures rpi wifi interface to a static ip address
           <ESSID> [password]
bridge <ESSID> <hotspotESSID>            configures the rpi to bridge the wlan interface over a hotspot
       [password] [hotspotPassword]
container <none|docker|balena>           enables (and start) the desired container
bluetooth <on|off>                       switches between bluetooth hotspot mode / regular bluetooth and starts the service
ap <local|internet> <ESSID> [password]   creates a mobile ap, which has two modes: local (no eth0 bridging), internet (eth0 bridging)
apchannel [channel]                      sets or prints the current ap channel
timezone <timezone>                      sets the timezone of the system
locale <locale>                          sets the system locale
ssh <on|off>                             enables or disables the ssh service
vnc <on|off>                             enables or disables the vnc server service
default                                  sets a raspbian back to default configuration
wificountry <country>                    sets the wifi country
upgrade                                  upgrades cli.sh package using npm
sshtunnel <add|remove|show>              helps adding an sshtunnel
          <portinterval> [user@host]
led [green|red] [mode]                   sets the led mode
rtc <on|off> [rasclock|ds3231]           sets up the rtc clock specified
ntp <local|internet>                     enables or disables time through ntp servers
networkmode                              outputs the current network mode
button <off|bluetooth>                   gives the gpio pin 18 an action
feedback <message>                       sends feedback
clone [device path]                      clones the current SDCard onto a secondary SDCard or specified device
restore [device path]                    restores a treehouses image to an SDCard or specified device
burn [device path]                       download and burns the latest treehouses image to the SDcard or specified device
rebootneeded                             shows if reboot is required to apply changes
internet                                 checks if the rpi has access to internet
services [service_name] [format]         outputs or install the desired service
        [install]
tor [start|stop|add|list|destroy]        deals with services on tor hidden network
```
