#!/usr/bin/env bats
load test-helper

@test "$clinom networkmode" {
  run "${clicmd}" networkmode
  assert_success
}

@test "$clinom networkmode info" {
  run "${clicmd}" networkmode info
  assert_success
}