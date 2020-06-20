#!/usr/bin/env bats
load test-helper

@test "$clinom led christmas" {
  run "${clicmd}" led christmas
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led heavymetal" {
  run "${clicmd}" led heavymetal
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led dance" {
  run "${clicmd}" led dance
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led kecak" {
  run "${clicmd}" led kecak
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led random" {
  run "${clicmd}" led random
  assert_success
}
