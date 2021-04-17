#!/usr/bin/env bats
load ../test-helper

@test "$clinom led lunarnewyear" {
  run "${clicmd}" led lunarnewyear
  assert_success && assert_output -p 'default-on'
}