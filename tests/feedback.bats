#!/usr/bin/env bats
load test-helper

@test "$clinom feedback" {
  run "${clicmd}" feedback cli-tests
  assert_success
}