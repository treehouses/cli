#!/usr/bin/env bats
load test-helper

@test "$clinom password raspberry" {
  run "${clicmd}" password change raspberry
  assert_success
}
