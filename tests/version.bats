#!/usr/bin/env bats
load test-helper

@test "$clinom version" {
  run "${clicmd}" version
  assert_success
}

@test "$clinom version contributors" {
  run "${clicmd}" version contributors
  assert_success
}

@test "$clinom version remote" {
  run "${clicmd}" version remote
  assert_success
}
