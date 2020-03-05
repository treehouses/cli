#!/usr/bin/env bats
load test-helper

@test "$clinom usb off" {
  run "${clicmd}" usb off
  assert_success
  assert_output -p 'turned off'
}

@test "$clinom usb on" {
  run "${clicmd}" usb on
  assert_success
  assert_output -p 'turned on'
}
