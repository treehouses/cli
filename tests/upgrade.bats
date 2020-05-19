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

@test "$clinom upgrade" {
  run "${clicmd}" upgrade
  assert_success
}

@test "$clinom upgrade force" {
  run "${clicmd}" upgrade force
  assert_success
}
@test "$clinom upgrade bluetooth" {
  run "${clicmd}" upgrade bluetooth
  assert_success
}

@test "$clinom upgrade check" {
  run "${clicmd}" upgrade check
  assert_success
}

@test "$clinom upgrade cli master" {
  run "${clicmd}" upgrade cli master
  assert_success
}