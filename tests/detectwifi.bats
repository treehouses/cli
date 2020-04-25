#!/usr/bin/env bats
load test-helper

@test "$clinom detectwifi" {
  run "${clicmd}" detectwifi
  assert_success
}
