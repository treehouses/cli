#!/usr/bin/env bats
load test-helper

@test "$clinom help" {
  run "${clicmd}" help
  assert_success
  assert_output -p 'cli.sh'
}

@test "$clinom help apchannel" {
  run "${clicmd}" help apchannel
  assert_success
  assert_output -p 'cli.sh apchannel'
}

@test "$clinom help aphidden" {
  run "${clicmd}" help aphidden
  assert_success
  assert_output -p 'cli.sh aphidden'
}

@test "$clinom help ap" {
  run "${clicmd}" help ap
  assert_success
  assert_output -p 'cli.sh ap'
}

@test "$clinom help blocker" {
  run "${clicmd}" help blocker
  assert_success
  assert_output -p 'cli.sh blocker'
}

@test "$clinom help bluetoothid" {
  run "${clicmd}" help bluetoothid
  assert_success
  assert_output -p 'cli.sh bluetoothid'
}

@test "$clinom help bluetooth" {
  run "${clicmd}" help bluetooth
  assert_success
  assert_output -p 'cli.sh bluetooth'
}

@test "$clinom help bootoption" {
  run "${clicmd}" help bootoption
  assert_success
  assert_output -p 'cli.sh bootoption'
}

@test "$clinom help bridge" {
  run "${clicmd}" help bridge
  assert_success
  assert_output -p 'cli.sh bridge'
}

@test "$clinom help burn" {
  run "${clicmd}" help burn
  assert_success
  assert_output -p 'cli.sh burn'
}

@test "$clinom help button" {
  run "${clicmd}" help button
  assert_success
  assert_output -p 'cli.sh button'
}

@test "$clinom help camera" {
  run "${clicmd}" help camera
  assert_success
  assert_output -p 'cli.sh camera'
}

@test "$clinom help clone" {
  run "${clicmd}" help clone
  assert_success
  assert_output -p 'cli.sh clone'
}

@test "$clinom help container" {
  run "${clicmd}" help container
  assert_success
  assert_output -p 'cli.sh container'
}

@test "$clinom help coralenv" {
  run "${clicmd}" help coralenv
  assert_success
  assert_output -p 'cli.sh coralenv'
}

@test "$clinom help cron" {
  run "${clicmd}" help cron
  assert_success
  assert_output -p 'cli.sh cron'
}

@test "$clinom help default" {
  run "${clicmd}" help default
  assert_success
  assert_output -p 'cli.sh default'
}

@test "$clinom help detectrpi" {
  run "${clicmd}" help detectrpi
  assert_success
  assert_output -p 'cli.sh detectrpi'
}

@test "$clinom help detect" {
  run "${clicmd}" help detect
  assert_success
  assert_output -p 'cli.sh detect'
}

@test "$clinom help discover" {
  run "${clicmd}" help discover
  assert_success
  assert_output -p 'cli.sh discover'
}

@test "$clinom help ethernet" {
  run "${clicmd}" help ethernet
  assert_success
  assert_output -p 'cli.sh ethernet'
}

@test "$clinom help expandfs" {
  run "${clicmd}" help expandfs
  assert_success
  assert_output -p 'cli.sh expandfs'
}

@test "$clinom help feedback" {
  run "${clicmd}" help feedback
  assert_success
  assert_output -p 'cli.sh feedback'
}

@test "$clinom help image" {
  run "${clicmd}" help image
  assert_success
  assert_output -p 'cli.sh image'
}

@test "$clinom help internet" {
  run "${clicmd}" help internet
  assert_success
  assert_output -p 'cli.sh internet'
}

@test "$clinom help led" {
  run "${clicmd}" help led
  assert_success
  assert_output -p 'cli.sh led'
}

@test "$clinom help locale" {
  run "${clicmd}" help locale
  assert_success
  assert_output -p 'cli.sh locale'
}

@test "$clinom help log" {
  run "${clicmd}" help log
  assert_success
  assert_output -p 'cli.sh log'
}

@test "$clinom help memory" {
  run "${clicmd}" help memory
  assert_success
  assert_output -p 'cli.sh memory'
}

@test "$clinom help networkmode" {
  run "${clicmd}" help networkmode
  assert_success
  assert_output -p 'cli.sh networkmode'
}

@test "$clinom help ntp" {
  run "${clicmd}" help ntp
  assert_success
  assert_output -p 'cli.sh ntp'
}

@test "$clinom help openvpn" {
  run "${clicmd}" help openvpn
  assert_success
  assert_output -p 'cli.sh openvpn'
}

@test "$clinom help password" {
  run "${clicmd}" help password
  assert_success
  assert_output -p 'cli.sh password'
}

@test "$clinom help rebootneeded" {
  run "${clicmd}" help rebootneeded
  assert_success
  assert_output -p 'cli.sh rebootneeded'
}

@test "$clinom help reboots" {
  run "${clicmd}" help reboots
  assert_success
  assert_output -p 'cli.sh reboots'
}

@test "$clinom help remote" {
  run "${clicmd}" help remote
  assert_success
  assert_output -p 'cli.sh remote'
}

@test "$clinom help rename" {
  run "${clicmd}" help rename
  assert_success
  assert_output -p 'cli.sh rename'
}

@test "$clinom help restore" {
  run "${clicmd}" help restore
  assert_success
  assert_output -p 'cli.sh restore'
}

@test "$clinom help rtc" {
  run "${clicmd}" help rtc
  assert_success
  assert_output -p 'cli.sh rtc'
}

@test "$clinom help sdbench" {
  run "${clicmd}" help sdbench
  assert_success
  assert_output -p 'cli.sh sdbench'
}

@test "$clinom help services" {
  run "${clicmd}" help services
  assert_success
  assert_output -p 'cli.sh services'
}

@test "$clinom help speedtest" {
  run "${clicmd}" help speedtest
  assert_success
  assert_output -p 'cli.sh speedtest'
}

@test "$clinom help sshkey" {
  run "${clicmd}" help sshkey
  assert_success
  assert_output -p 'cli.sh sshkey'
}

@test "$clinom help ssh" {
  run "${clicmd}" help ssh
  assert_success
  assert_output -p 'cli.sh ssh'
}

@test "$clinom help sshtunnel" {
  run "${clicmd}" help sshtunnel
  assert_success
  assert_output -p 'cli.sh sshtunnel'
}

@test "$clinom help staticwifi" {
  run "${clicmd}" help staticwifi
  assert_success
  assert_output -p 'cli.sh staticwifi'
}

@test "$clinom help temperature" {
  run "${clicmd}" help temperature
  assert_success
  assert_output -p 'cli.sh temperature'
}

@test "$clinom help timezone" {
  run "${clicmd}" help timezone
  assert_success
  assert_output -p 'cli.sh timezone'
}

@test "$clinom help tor" {
  run "${clicmd}" help tor
  assert_success
  assert_output -p 'cli.sh tor'
}

@test "$clinom help upgrade" {
  run "${clicmd}" help upgrade
  assert_success
  assert_output -p 'cli.sh upgrade'
}

@test "$clinom help usb" {
  run "${clicmd}" help usb
  assert_success
  assert_output -p 'cli.sh usb'
}

@test "$clinom help verbose" {
  run "${clicmd}" help verbose
  assert_success
  assert_output -p 'cli.sh verbose'
}

@test "$clinom help version" {
  run "${clicmd}" help version
  assert_success
  assert_output -p 'cli.sh version'
}

@test "$clinom help vnc" {
  run "${clicmd}" help vnc
  assert_success
  assert_output -p 'cli.sh vnc'
}

@test "$clinom help wificountry" {
  run "${clicmd}" help wificountry
  assert_success
  assert_output -p 'cli.sh wificountry'
}

@test "$clinom help wifihidden" {
  run "${clicmd}" help wifihidden
  assert_success
  assert_output -p 'cli.sh wifihidden'
}

@test "$clinom help wifi" {
  run "${clicmd}" help wifi
  assert_success
  assert_output -p 'cli.sh wifi'
}

@test "$clinom help wifistatus" {
  run "${clicmd}" help wifistatus
  assert_success
  assert_output -p 'cli.sh wifistatus'
}