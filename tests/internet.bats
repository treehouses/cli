#!/usr/bin/env bats
load test-helper

@test "$clinom internet" {
  run "${clicmd}" internet
  assert_success && assert_output -p 'true'
}