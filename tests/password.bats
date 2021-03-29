#!/usr/bin/env bats
load test-helper

@test "$clinom password change raspberry" {
  run "${clicmd}" password change raspberry
  assert_success
}

@test "$clinom password disable" {
  run "${clicmd}" password disable
  assert_success 
}

@test "$clinom password enable" {
  run "${clicmd}" password enable
  assert_success
}