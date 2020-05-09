#!/usr/bin/env bats
load test-helper

@test "$clinom detect" {
  run "${clicmd}" detect
  assert_success
}

@test "$clinom detect bluetooth" {
  run "${clicmd}" detect bluetooth
  assert_success
}

@test "$clinom detect rpi" {
  run "${clicmd}" detect rpi
  assert_success
}

@test "$clinom detect rpi model" {
  run "${clicmd}" detect rpi model
  assert_success
}

@test "$clinom detect wifi" {
  run "${clicmd}" detect wifi
  assert_success
}

@test "$clinom detect arm" {
  run "${clicmd}" detect arm
  assert_success
}
