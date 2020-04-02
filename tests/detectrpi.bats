#!/usr/bin/env bats
load test-helper

@test "$clinom detectrpi" {
  run "${clicmd}" detectrpi
  assert_success
}

@test "$clinom detectrpi model" {
  run "${clicmd}" detectrpi model
  assert_success
}