#!/usr/bin/env bats
load test-helper

@test "$clinom detect" {
  run "${clicmd}" detect
  assert_success
}