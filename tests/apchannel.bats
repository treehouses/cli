#!/usr/bin/env bats
load test-helper

@test "$clinom apchannel" {
  check_networkmode
  run "${clicmd}" apchannel
  assert_success
}

@test "$clinom apchannel 6" {
  check_networkmode
  run "${clicmd}" apchannel 6
  assert_success && assert_output -p 'Success'
}
