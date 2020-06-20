#!/usr/bin/env bats
load test-helper

@test "$clinom led newyear" {
  run "${clicmd}" led newyear
  assert_success && assert_output -p 'default-on'
}

@test "$clinom led lunarnewyear" {
  run "${clicmd}" led lunarnewyear
  assert_success && assert_output -p 'default-on'
}

@test "$clinom led valentine" {
  run "${clicmd}" led valentine
  assert_success && assert_output -p 'heartbeat'
}

