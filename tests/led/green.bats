#!/usr/bin/env bats
load ../test-helper

@test "$clinom led green heartbeat" {
  run "${clicmd}" led green heartbeat
  assert_success && assert_output -p 'heartbeat'
}
