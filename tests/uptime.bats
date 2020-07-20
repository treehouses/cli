#!/usr/bin/env bats
load test-helper

@test "$clinom uptime" {
  run "${clicmd}" uptime
  assert_success
}

@test "$clinom uptime boot" {
  run "${clicmd}" uptime boot
  assert_success
}

@test "$clinom uptime start" {
  run "${clicmd}" uptime start
  assert_success
}

@test "$clinom uptime stop" {
  run "${clicmd}" uptime stop
  assert_success
}