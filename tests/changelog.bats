#!/usr/bin/env bats
load test-helper

@test "$clinom changelog" {
  run "${clicmd}" changelog
  assert_success
}