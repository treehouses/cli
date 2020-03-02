#!/bin/bash
err_report() {
    echo "Error on line $1"
}

trap 'err_report $LINENO' ERR

function t {
  echo "running $@"
  ./cli.sh "$@"
}

{
  t help apchannel
  t help camera
  t help ethernet
  t help memory
  t help rtc
  t help upgrade
  t help aphidden
  t help clone
  t help expandfs
  t help networkmode
  t help services
  t help usb
  t help ap
  t help config
  t help feedback
  t help ntp
  t help speedtest
  t help verbose
  t help blocker
  t help container
  t help globals
  t help openvpn
  t help sshkey
  t help version
  t help bluetoothid
  t help coralenv
  t help help
  t help password
  t help sshvnc
  t help bluetooth
  t help cron
  t help image
  t help rebootneeded
  t help sshtunnel
  t help wificountry
  t help bootoption
  t help default
  t help internet
  t help reboots
  t help staticwifi
  t help wifihidden
  t help bridge
  t help detectrpi
  t help led
  t help remote
  t help temperature
  t help wifi
  t help burn
  t help detect
  t help locale
  t help rename
  t help timezone
  t help wifistatus
  t help button
  t help discover
  t help log
  t help restore
  t help tor
  t help
  t help dsfsdf
  t help tor adfsfsd
} > ./help.txt

{
  t
  t dfasfsa
  t fsdfsdfs sdfsdfsd

  t verbose
  t verbose on
  t verbose off
  t verbose sdfsdfs
  t verbose off dfsfsd

  t expandfs
  t expandfs sdfsdafsa

  t rename PiInTheSky
  echo "test: hostname = $(hostname)"
  t rename fedorasfa sdfasdfsadf
  echo "test: hostname = $(hostname)"
  t rename ffff ffff ffff
  echo "test: hostname = $(hostname)"

  t password
  echo "test: try logging in"
  read -n 1 -s -r -p "Press any key to continue"
  t password raspberry
  echo "test: try logging in"
  read -n 1 -s -r -p "Press any key to continue"
  t password raspberry pi
  echo "test: try logging in"
  read -n 1 -s -r -p "Press any key to continue"
  t password raspberry pi sandwich
  echo "test: try logging in"
  read -n 1 -s -r -p "Press any key to continue"

  t sshkey add "leroy jenkinssssssssssssssssssssssssssssssssss"
  echo "test: authorized keys: $(t sshkey list | grep \"leroy\")"
  t sshkey add sfdsdf sfdsdf
  echo "test: authorized keys: $(t sshkey list | grep \"sfdsdf\")"
  t sshkey list
  t sshkey list leroy
  t sshkey delete "leroy jenkinssssssssssssssssssssssssssssssssss"
  echo "test: authorized keys: $(t sshkey list | grep \"leroy\")"
  t sshkey delete sfdsdf sfdsdf
  echo "test: authorized keys: $(t sshkey list | grep \"sfdsdf\")"
  t sshkey deleteall
  echo "test: print sshkey list"
  t sshkey list
  t sshkey github
  t sshkey github adduser lillyxxx
  echo "test: authorized keys: $(t sshkey list | grep \"lillyxxx\")"
  t sshkey github adduser LILLYXXX
  echo "test: authorized keys: $(t sshkey list | grep \"LILLYXXX\")"
  t sshkey github adduser LilLYxxX
  echo "test: authorized keys: $(t sshkey list | grep \"LilLYxxX\")"
  t sshkey github adduser dskflasdlkfjadslfkdsajflsadjfsadlk
  echo "test: authorized keys: $(t sshkey list | grep \"dskflasdlkfjadslfkdsajflsadjfsadlk\")"
  t sshkey github adduser dskflas sdfsfdsfs
  echo "test: authorized keys: $(t sshkey list | grep \"dskflas\")"
  t sshkey github deleteuser lillyxxx
  echo "test: authorized keys: $(t sshkey list | grep \"lillyxxx\")"
  t sshkey github adduser lillyxxx
  t sshkey github deleteuser LILLYXXX
  echo "test: authorized keys: $(t sshkey list | grep \"lillyxxx\")"
  t sshkey github adduser lillyxxx
  t sshkey github deleteuser LilLYxxX
  echo "test: authorized keys: $(t sshkey list | grep \"lillyxxx\")"
  t sshkey github deleteuser dskflasdlkfjadslfkdsajflsadjfsadlk
  echo "test: authorized keys: $(t sshkey list | grep \"dskflasdlkfjadslfkdsajflsadjfsadlk\")"
  t sshkey github deleteuser dskflas sdfsfdsfs
  echo "test: authorized keys: $(t sshkey list | grep \"dskflas\")"
  t image
  t image sdfsdfsd
  t detectrpi
  t detectrpi sdfdsfds
  t detectrpi model
  t detectrpi model dskfla
  t detect
  t detect dsfdsfsd

  # (WIP) Needs to be added to tests
  #t ethernet <ip> <mask> <gateway> <dns>      configures rpi network interface to a static ip address
  #t discover <scan|interface|ping|ports|mac>  performs network scan and discovers all raspberry pis on the network
  #t          <rpi> [ipaddress|url|macaddress]
  #t wifi <ESSID> [password]                   connects to a wifi network
  #t wifihidden <ESSID> [password]             connects to a hidden wifi network
  #t staticwifi <ip> <mask> <gateway> <dns>    configures rpi wifi interface to a static ip address
  #t            <ESSID> [password]
  #t wifistatus                                displays signal strength in dBm and layman nomenclature
  #t bridge <ESSID> <hotspotESSID>             configures the rpi to bridge the wlan interface over a hotspot
  #t        [password] [hotspotPassword]
  #t ap <local|internet> <ESSID> [password]    creates a mobile ap, which has two modes: local (no eth0 bridging), internet (eth0 bridging)
  #t aphidden <local|internet> <ESSID>         creates a hidden mobile ap with or without internet access
  #t          [password]
  #t apchannel [channel]                       sets or prints the current ap channel

  #t bluetooth <on|off|pause|mac|id> [number]  switches bluetooth from regular to hotspot mode and shows id or MAC address
  #t sshtunnel <add|remove|list|check|notice>  helps adding an sshtunnel
  #t           <key|portinterval> [user@host]
  #t button <off|bluetooth>                    gives the gpio pin 18 an action
  #t clone [device path]                       clones the current SDCard onto a secondary SDCard or specified device
  #t restore [device path]                     restores at image to an SDCard or specified device
  #t burn [device path]                        download and burns the latestt image to the SDcard or specified device
  #t reboots <now|in|cron>                     reboots at given frequency | removes it if reboot task active
  #t         <daily|weekly|monthly>
  #t services [service_name] [command]         executes the given command on the specified service
  #t tor [list|add|delete|deleteall|start]     deals with services on tor hidden network
  #t     [stop|destroy|notice|status|refresh]
  #t openvpn [use|show|delete]                 helps setting up an openvpn client
  #t         [notice|start|stop|load]
  #t coralenv [install|demo-on|demo-off]       plays with the coral environmental board
  #t          [demo-always-on]
  #t camera [on|off|capture]                   enables camera, disables camera, captures png photo
  #t cron [list|add|delete|deleteall]          adds, deletes a custom cron job or deletes, lists all cron jobs
  #t      [0W|tor|timestamp]                   adds premade cron job (or removes it if already active)
  #t remote [status|upgrade|services]          helps witht remote android app

  t container
  t container kjhkjhkj
  t container docker
  t container balena
  t container none
  t container docker dfdsf
  t container balena sdfsdfs
  t container none dsfadsfa
  t timezone
  t timezone dsfdsfsd
  t timezone sdfdsfds dsfdsfsd
  t timezone Etc/GMT-3
  t timezone Etc/GMT-3 dfdsfdsfds
  t locale
  t locale en_US
  t locale sdfsdfs
  t locale en_US sdfdsfsd
  t ssh
  t ssh off
  t ssh sdfds
  t ssh on sdfdsf
  t ssh on
  t vnc
  t vnc on
  t vnc off
  t vnc info
  t vnc dsfsfds
  t vnc on sdfsfsd
  t default
  t default sdfdsfds
  t default network
  t default tunnel
  t default notice
  t default network sdfdsfs
  t wificountry
  t wificountry US
  t wificountry sdfdsfdsf
  t wificountry US sdfdsfds
  t upgrade
  t upgrade sdfdsfs
  t upgrade -f
  t upgrade 3.3.3
  t upgrade -f 3.3.3
  t upgrade --check
  t upgrade --check 3.3.3
  t upgrade --check -f 3.3.3
  t led
  t led dfsdfsd
  t led red
  t led green heartbeat
  t led red default-on
  t led red sdfdsfsd
  t led green dsfsdf
  t led dance
  t led thanksgiving
  t led christmas
  t led lunarnewyear
  t led valentine
  t led carnival
  t led onam
  t led dance sdfdsfs
  t rtc
  t rtc off
  t rtc on
  t rtc dfsdds
  t rtc on rasclock
  t rtc on sdfdsfs
  t rtc on ds3231
  t ntp
  t ntp sdfsdf
  t ntp local
  t ntp local sdfdsfs
  t ntp internet
  t networkmode
  t networkmode info
  t networkmode info sdfdss
  t networkmode sdfdsfds
  t feedback
  t feedback testscriptisrunning
  t feedback testscriptrun2 sfsdf
  t rebootneeded
  t rebootneeded sdfdsfs
  t internet
  t internet dsfdsf
  t bootoption
  t bootoption sdfsdfsd
  t bootoption console dfsdfsd
  t bootoption console
  t bootoption console autologin
  t bootoption console autologin dfsdfdssf
  t bootoption desktop
  t bootoption desktop autologin
  t memory
  t memory total
  t memory used
  t memory free
  t memory dfsdf
  t memory -g
  t memory -m
  t memory -g free
  t memory -m total
  t memory -m total dfsdfsd
  t memory -m -g total
  t memory -m -g total dsfsdf
  t temperature
  t temperature sdfsdfsd
  t temperature celsius
  t temperature fahrenheit
  t speedtest
  t speedtest dsfsdf
  t speedtest -h
  t usb
  t usb off
  t usb on
  t log
  t log dsfdsf
  t log 0
  t log 1
  t log 2
  t log 3
  t log 4
  t log show
  t log show fsdfsdfs
  t log show 3
  t log show 7 dsfsdfsd
  t log max
  t log 0
  t blocker
  t blocker sdfdsfs
  t blocker 0
  t blocker 0 dfsdfsd
  t blocker 1
  t blocker 2
  t blocker 3
  t blocker 4
  t blocker max
  t blocker 0
} > ./output.txt