#!/usr/bin/env bats
load ../test-helper

@test "$clinom led valentine" {
  run "${clicmd}" led valentine
  assert_success && assert_output -p 'heartbeat'
}
