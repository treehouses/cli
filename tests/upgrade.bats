#!/usr/bin/env bats
load test-helper

@test "$clinom upgrade 1.14.0" {
  run "${clicmd}" upgrade 1.14.0
  assert_success
}

@test "$clinom upgrade --check" {
  run "${clicmd}" upgrade --check
  assert_success
}

@test "$clinom upgrade -f" {
  run "${clicmd}" upgrade -f
  assert_success
}

@test "$clinom upgrade" {
  run "${clicmd}" upgrade
  assert_success
}