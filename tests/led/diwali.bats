#!/usr/bin/env bats
load ../test-helper

@test "$clinom led diwali" {
  run "${clicmd}" led diwali
  assert_success && assert_output -p 'heartbeat'
}
