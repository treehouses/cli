#!/usr/bin/env bats
load test-helper

@test "$clinom margaritas" {
  run "${clicmd}" margaritas
  assert_success
}
