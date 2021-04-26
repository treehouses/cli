#!/usr/bin/env bats
load ../test-helper

@test "$clinom led blackhistorymonth" {
  run "${clicmd}" led blackhistorymonth
  assert_success && assert_output -p 'heartbeat'
}
