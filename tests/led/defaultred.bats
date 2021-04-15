#!/usr/bin/env bats
load ../test-helper

@test "$clinom led red default-on" {
  run "${clicmd}" led red default-on
  assert_success && assert_output -p 'default-on'
}