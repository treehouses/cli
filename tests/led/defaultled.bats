#!/usr/bin/env bats
load ../test-helper

@test "$clinom led" {
  run "${clicmd}" led
  assert_success && assert_output -p 'green led'
}