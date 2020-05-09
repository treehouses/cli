#!/usr/bin/env bats
load test-helper

@test "$clinom power conservative" {
  run "${clicmd}" power conservative
  assert_success
}

@test "$clinom power current" {
  run "${clicmd}" power current
  assert_success
}

@test "$clinom power default" {
  run "${clicmd}" power default
  assert_success
}

@test "$clinom power freq" {
  run "${clicmd}" power freq
  assert_success
}

@test "$clinom power ondemand" {
  run "${clicmd}" power ondemand
  assert_success
}

@test "$clinom power performance" {
  run "${clicmd}" power performance
  assert_success
}

@test "$clinom power powersave" {
  run "${clicmd}" power powersave
  assert_success
}

@test "$clinom power status" {
  run "${clicmd}" power status
  assert_success
}

@test "$clinom power userspace" {
  run "${clicmd}" power userspace
  assert_success
}
