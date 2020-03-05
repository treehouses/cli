#!/usr/bin/env bats
load test-helper

@test "$clinom wifistatus" {
  run "${clicmd}" wifistatus
  assert_success
}