#!/usr/bin/env bats
load ../test-helper

@test "$clinom led dance" {
  run "${clicmd}" led dance
  assert_success && assert_output -p 'heartbeat'
}