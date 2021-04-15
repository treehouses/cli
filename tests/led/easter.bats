#!/usr/bin/env bats
load ../test-helper

@test "$clinom led easter" {
  run "${clicmd}" led easter
  assert_success && assert_output -p 'heartbeat'
}