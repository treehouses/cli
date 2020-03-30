#!/usr/bin/env bats
load test-helper

@test "$clinom detectarm" {
  run "${clicmd}" detectarm
  assert_success
}
