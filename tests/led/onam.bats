#!/usr/bin/env bats
load ../test-helper

@test "$clinom led onam" {
  run "${clicmd}" led onam
  assert_success && assert_output -p 'heartbeat'
}