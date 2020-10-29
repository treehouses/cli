#!/usr/bin/env bats
load test-helper

@test "$clinom wificountry US" {
  run "${clicmd}" wificountry US
  assert_success && assert_output -p 'country has been set'
}

@test "$clinom wificountry" {
  run "${clicmd}" wificountry
  assert_success && assert_output -p 'country='
}