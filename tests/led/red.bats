#!/usr/bin/env bats
load ../test-helper

@test "$clinom led red" {
  run "${clicmd}" led red
  assert_success && assert_output -p 'default-on'
}
