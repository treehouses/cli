#!/usr/bin/env bats
load ../test-helper

@test "$clinom led lantern" {
  run "${clicmd}" led lantern
  assert_success && assert_output -p 'heartbeat'
}