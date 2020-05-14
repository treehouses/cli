#!/usr/bin/env bats
load test-helper

@test "$clinom uptime" {
  run "${clicmd}" power conservative
  assert_success
}

@test "$clinom uptime boot" {
  run "${clicmd}" uptime current
  assert_success
}

@test "$clinom uptime start" {
  run "${clicmd}" uptime default
  assert_success
}

@test "$clinom uptime stop" {
  run "${clicmd}" uptime freq
  assert_success
}