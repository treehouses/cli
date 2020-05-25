#!/usr/bin/env bats
load test-helper

@test "$clinom tether" {
  run "${clicmd}" tether 
  assert_success
}
