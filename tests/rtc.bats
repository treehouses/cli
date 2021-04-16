#!/usr/bin/env bats
load test-helper

@test "$clinom rtc on rasclock" {
  run "${clicmd}" rtc on rasclock
  assert_success && assert_output -p 'Success: clock changed. Please reboot'
}

@test "$clinom rtc on PCF8523" {
  run "${clicmd}" rtc on PCF8523
  assert_success && assert_output -p 'Success: clock changed. Please reboot'
}

@test "$clinom rtc on DS1307" {
  run "${clicmd}" rtc on DS1307
  assert_success && assert_output -p 'Success: clock changed. Please reboot'
}

@test "$clinom rtc on ds3231" {
  run "${clicmd}" rtc on ds3231
  assert_success && assert_output -p 'Success: clock changed. Please reboot'
}

@test "$clinom rtc off" {
  run "${clicmd}" rtc off
  assert_success && assert_output -p 'Success: clock changed. Please reboot'
}

@test "$clinom rtc on asdf (invalid clock)" {
  run "${clicmd}" rtc on asdf
  assert_failure && assert_output -p 'Error: the clock is not supported.'
}
