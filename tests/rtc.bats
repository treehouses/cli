#!/usr/bin/env bats
load test-helper

@test "$clinom rtc on rasclock" {
  run "${clicmd}" rtc on rasclock
  assert_success && assert_output -p 'Success'
}

@test "$clinom rtc on ds3231" {
  run "${clicmd}" rtc on ds3231
  assert_success && assert_output -p 'Success'
}

@test "$clinom rtc off" {
  run "${clicmd}" rtc off
  assert_success && assert_output -p 'Success'
}