#!/usr/bin/env bats
load ../test-helper

@test "$clinom led dragonboat" {
  run "${clicmd}" led labourday
  assert_success && assert_output -p 'labourday'
}
