#!/usr/bin/env bats
load test-helper

@test "$clinom discover rpi" {
  run "${clicmd}" discover rpi
  assert_success
}

@test "$clinom discover scan 192.168.0.1" {
  run "${clicmd}" discover scan 192.168.0.1
  assert_success
}

@test "$clinom discover scan scanme.nmap.org" {
  run "${clicmd}" discover scan scanme.nmap.org
  assert_success
}

@test "$clinom discover interface" {
  run "${clicmd}" discover interface
  assert_success
}

@test "$clinom discover ping google.com" {
  run "${clicmd}" discover ping google.com
  assert_success
}

@test "$clinom discover ports localhost" {
  run "${clicmd}" discover ports localhost
  assert_success
}

@test "$clinom discover mac b8:29:eb:9f:42:8b" {
  run "${clicmd}" discover mac b8:29:eb:9f:42:8b
  assert_success
}