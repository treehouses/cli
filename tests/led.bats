#!/usr/bin/env bats
load test-helper

@test "$clinom led green heartbeat" {
  run "${clicmd}" led green heartbeat
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led red default-on" {
  run "${clicmd}" led red default-on
  assert_success && assert_output -p 'default-on'
}

@test "$clinom led" {
  run "${clicmd}" led
  assert_success && assert_output -p 'green led'
}

@test "$clinom led red" {
  run "${clicmd}" led red
  assert_success && assert_output -p 'default-on'
}

@test "$clinom led dance" {
  run "${clicmd}" led dance
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led thanksgiving" {
  run "${clicmd}" led thanksgiving
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led eid" {
  run "${clicmd}" led eid
  assert_success && assert_output -p 'heartbeat' 
}

@test "$clinom led christmas" {
  run "${clicmd}" led christmas
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led lunarnewyear" {
  run "${clicmd}" led lunarnewyear
  assert_success && assert_output -p 'default-on'
}

@test "$clinom led valentine" {
  run "${clicmd}" led valentine
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led carnival" {
  run "${clicmd}" led carnival
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led onam" {
  run "${clicmd}" led onam
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led diwali" {
  run "${clicmd}" led diwali
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led dragonboat" {
  run "${clicmd}" led dragonboat
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led heavymetal" {
  run "${clicmd}" led heavymetal
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led stpatricks" {
  run "${clicmd}" led stpatricks
  assert_success && assert_output -p 'red led'
}

@test "$clinom led easter" {
  run "${clicmd}" led easter
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led lantern" {
  run "${clicmd}" led lantern
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
