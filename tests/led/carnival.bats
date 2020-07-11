#!/usr/bin/env bats
load ../test-helper

@test "$clinom led carnival" {
  run "${clicmd}" led carnival
  assert_success && assert_output -p 'heartbeat'
}