#!/usr/bin/env bats
load ../test-helper

@test "$clinom led eid" {
  run "${clicmd}" led eid
  assert_success && assert_output -p 'heartbeat' 
}
