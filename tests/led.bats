#!/usr/bin/env bats
load test-helper

@test "$clinom led green heartbeat" {
  run "${clicmd}" led green heartbeat
  assert_success
  assert_output -p 'heartbeat'
}

@test "$clinom led red default-on" {
  run "${clicmd}" led red default-on
  assert_success
  assert_output -p 'default-on'
}

@test "$clinom led" {
  run "${clicmd}" led
  assert_success
  assert_output -p 'green led'
}

@test "$clinom led red" {
  run "${clicmd}" led red
  assert_success
  assert_output -p 'default-on'
}

@test "$clinom led dance" {
  run "${clicmd}" led dance
  assert_success
  assert_output -p 'heartbeat'
}

@test "$clinom led thanksgiving" {
  run "${clicmd}" led thanksgiving
  assert_success
  assert_output -p 'heartbeat'
}

@test "$clinom led christmas" {
  run "${clicmd}" led christmas
  assert_success
  assert_output -p 'heartbeat'
}

@test "$clinom led lunarnewyear" {
  run "${clicmd}" led lunarnewyear
  assert_success
  assert_output -p 'default-on'
}

@test "$clinom led valentine" {
  run "${clicmd}" led valentine
  assert_success
  assert_output -p 'heartbeat'
}

@test "$clinom led carnival" {
  run "${clicmd}" led carnival
  assert_success
  assert_output -p 'heartbeat'
}

@test "$clinom led onam" {
  run "${clicmd}" led onam
  assert_success
  assert_output -p 'heartbeat'
}