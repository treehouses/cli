#!/usr/bin/env bats
load ../test-helper

@test "$clinom led christmas" {
  run "${clicmd}" led christmas
  assert_success && assert_output -p 'heartbeat'
}
