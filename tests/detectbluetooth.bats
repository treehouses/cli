#!/usr/bin/env bats
load test-helper

@test "$clinom detectbluetooth" {
  run "${clicmd}" detectbluetooth
  assert_success
}
