#!/usr/bin/env bats
load ../test-helper

@test "$clinom led dragonboat" {
  run "${clicmd}" led dragonboat
  assert_success && assert_output -p 'default-on'
}