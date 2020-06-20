#!/usr/bin/env bats
load test-helper

@test "$clinom led carnival" {
  run "${clicmd}" led carnival
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led lantern" {
  run "${clicmd}" led lantern
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led stpatricks" {
  run "${clicmd}" led stpatricks
  assert_success && assert_output -p 'red led'
}

@test "$clinom led easter" {
  run "${clicmd}" led easter
  assert_success && assert_output -p 'heartbeat'
}

