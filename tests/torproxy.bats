#!/usr/bin/env bats
load test-helper

@test "$clinom torproxy on" {
  run "${clicmd}" torproxy on
  assert_success
}

@test "$clinom torproxy off" {
  run "${clicmd}" torproxy off
  assert_success
}
