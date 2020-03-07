#!/usr/bin/env bats
load test-helper

@test "$clinom bluetoothid" {
  run "${clicmd}" bluetoothid
  assert_success
}

@test "$clinom bluetoothid number" {
  run "${clicmd}" bluetoothid number
  assert_success
}
