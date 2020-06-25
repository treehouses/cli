#!/usr/bin/env bats
load ../test-helper

@test "$clinom led heavymetal" {
  run "${clicmd}" led heavymetal
  assert_success && assert_output -p 'heartbeat'
}
