#!/usr/bin/env bats
load test-helper

@test "$clinom rebootneeded" {
  run "${clicmd}" rebootneeded
  assert_success
}