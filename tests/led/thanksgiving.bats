#!/usr/bin/env bats
load ../test-helper

@test "$clinom led thanksgiving" {
  run "${clicmd}" led thanksgiving
  assert_success && assert_output -p 'heartbeat'
}