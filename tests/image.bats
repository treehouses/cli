#!/usr/bin/env bats
load test-helper

@test "$clinom image" {
  run "${clicmd}" image
  assert_success && assert_output -p 'release'
}