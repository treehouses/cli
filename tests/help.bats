#!/usr/bin/env bats
load test-helper

@test "$clinom help" {
  run "${clicmd}" help
  assert_success
}

@test "$clinom help apchannel" {
  run "${clicmd}" help apchannel
  assert_success
}

@test "$clinom help aphidden" {
  run "${clicmd}" help aphidden
  assert_success
}

@test "$clinom help ap" {
  run "${clicmd}" help ap
  assert_success
}

@test "$clinom help blocker" {
  run "${clicmd}" help blocker
  assert_success
}

@test "$clinom help bluetooth" {
  run "${clicmd}" help bluetooth
  assert_success
}

@test "$clinom help bootoption" {
  run "${clicmd}" help bootoption
  assert_success
}

@test "$clinom help bridge" {
  run "${clicmd}" help bridge
  assert_success
}

@test "$clinom help burn" {
  run "${clicmd}" help burn
  assert_success
}

@test "$clinom help button" {
  run "${clicmd}" help button
  assert_success
}

@test "$clinom help camera" {
  run "${clicmd}" help camera
  assert_success
}

@test "$clinom help clone" {
  run "${clicmd}" help clone
  assert_success
}

@test "$clinom help container" {
  run "${clicmd}" help container
  assert_success
}

@test "$clinom help coralenv" {
  run "${clicmd}" help coralenv
  assert_success
}

@test "$clinom help cron" {
  run "${clicmd}" help cron
  assert_success
}

@test "$clinom help default" {
  run "${clicmd}" help default
  assert_success
}

@test "$clinom help detectrpi" {
  run "${clicmd}" help detectrpi
  assert_success
}

@test "$clinom help detect" {
  run "${clicmd}" help detect
  assert_success
}

@test "$clinom help discover" {
  run "${clicmd}" help discover
  assert_success
}

@test "$clinom help ethernet" {
  run "${clicmd}" help ethernet
  assert_success
}

@test "$clinom help expandfs" {
  run "${clicmd}" help expandfs
  assert_success
}

@test "$clinom help feedback" {
  run "${clicmd}" help feedback
  assert_success
}

@test "$clinom help image" {
  run "${clicmd}" help image
  assert_success
}

@test "$clinom help internet" {
  run "${clicmd}" help internet
  assert_success
}

@test "$clinom help led" {
  run "${clicmd}" help led
  assert_success
}

@test "$clinom help locale" {
  run "${clicmd}" help locale
  assert_success
}

@test "$clinom help log" {
  run "${clicmd}" help log
  assert_success
}

@test "$clinom help memory" {
  run "${clicmd}" help memory
  assert_success
}

@test "$clinom help networkmode" {
  run "${clicmd}" help networkmode
  assert_success
}

@test "$clinom help ntp" {
  run "${clicmd}" help ntp
  assert_success
}

@test "$clinom help openvpn" {
  run "${clicmd}" help openvpn
  assert_success
}

@test "$clinom help password" {
  run "${clicmd}" help password
  assert_success
}

@test "$clinom help rebootneeded" {
  run "${clicmd}" help rebootneeded
  assert_success
}

@test "$clinom help reboots" {
  run "${clicmd}" help reboots
  assert_success
}

@test "$clinom help remote" {
  run "${clicmd}" help remote
  assert_success
}

@test "$clinom help rename" {
  run "${clicmd}" help rename
  assert_success
}

@test "$clinom help restore" {
  run "${clicmd}" help restore
  assert_success
}

@test "$clinom help rtc" {
  run "${clicmd}" help rtc
  assert_success
}

@test "$clinom help sdbench" {
  run "${clicmd}" help sdbench
  assert_success
}

@test "$clinom help services" {
  run "${clicmd}" help services
  assert_success
}

@test "$clinom help speedtest" {
  run "${clicmd}" help speedtest
  assert_success
}

@test "$clinom help sshkey" {
  run "${clicmd}" help sshkey
  assert_success
}

@test "$clinom help ssh" {
  run "${clicmd}" help ssh
  assert_success
}

@test "$clinom help sshtunnel" {
  run "${clicmd}" help sshtunnel
  assert_success
}

@test "$clinom help staticwifi" {
  run "${clicmd}" help staticwifi
  assert_success
}

@test "$clinom help temperature" {
  run "${clicmd}" help temperature
  assert_success
}

@test "$clinom help timezone" {
  run "${clicmd}" help timezone
  assert_success
}

@test "$clinom help tor" {
  run "${clicmd}" help tor
  assert_success
}

@test "$clinom help upgrade" {
  run "${clicmd}" help upgrade
  assert_success
}

@test "$clinom help usb" {
  run "${clicmd}" help usb
  assert_success
}

@test "$clinom help verbose" {
  run "${clicmd}" help verbose
  assert_success
}

@test "$clinom help version" {
  run "${clicmd}" help version
  assert_success
}

@test "$clinom help vnc" {
  run "${clicmd}" help vnc
  assert_success
}

@test "$clinom help wificountry" {
  run "${clicmd}" help wificountry
  assert_success
}

@test "$clinom help wifihidden" {
  run "${clicmd}" help wifihidden
  assert_success
}

@test "$clinom help wifi" {
  run "${clicmd}" help wifi
  assert_success
}

@test "$clinom help wifistatus" {
  run "${clicmd}" help wifistatus
  assert_success
}
