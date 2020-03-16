#!/usr/bin/env bats
load test-helper

@test "$clinom expandfs" {
  run "${clicmd}" expandfs
  assert_success && assert_output -p 'will be expanded'
}