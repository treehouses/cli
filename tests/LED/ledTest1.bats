#!/usr/bin/env bats
load test-helper

@test "$clinom led green heartbeat" {
  run "${clicmd}" led green heartbeat
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led red default-on" {
  run "${clicmd}" led red default-on
  assert_success && assert_output -p 'default-on'
}

@test "$clinom led" {
  run "${clicmd}" led
  assert_success && assert_output -p 'green led'
}

@test "$clinom led red" {
  run "${clicmd}" led red
  assert_success && assert_output -p 'default-on'
}
