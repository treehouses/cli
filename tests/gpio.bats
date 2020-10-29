#!/usr/bin/env bats
load test-helper

@test "$clinom gpio" {
  run "${clicmd}" gpio
  assert_success
}
