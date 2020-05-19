#!/usr/bin/env bats
load test-helper

@test "$clinom button off" {
  run "${clicmd}" button off
  assert_success && assert_output -p 'button disabled'
}

@test "$clinom button bluetooth (check button...press any key to continue)" {
  run "${clicmd}" button bluetooth
  assert_success && assert_output -p 'button enabled'
  read -n 1 -s -r
}
