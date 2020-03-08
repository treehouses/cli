#!/usr/bin/env bats
load test-helper

@test "$clinom version" {
  run "${clicmd}" version
  assert_success }