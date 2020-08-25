#!/usr/bin/env bats
load ../test-helper

@test "$clinom led labourday" {
  run "${clicmd}" led labourday
  assert_success && assert_output -p 'labourday'
}
