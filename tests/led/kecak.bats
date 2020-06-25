#!/usr/bin/env bats
load ../test-helper

@test "$clinom led kecak" {
  run "${clicmd}" led kecak
  assert_success && assert_output -p 'heartbeat'
}
