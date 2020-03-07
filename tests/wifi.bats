#!/usr/bin/env bats
load test-helper

@test "$clinom wifi " {
  run "${clicmd}" wifi
  assert_success
  assert_output -p 'disabled'
}
