#!/usr/bin/env bats
load ../test-helper

@test "$clinom led stpatricks" {
  run "${clicmd}" led stpatricks
  assert_success && assert_output -p 'red led'
}