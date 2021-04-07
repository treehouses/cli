#!/usr/bin/env bats
load test-helper

@test "$clinom wificountry" {
  run "${clicmd}" wificountry
  assert_success && assert_output -p 'country='
}

@test "$clinom wificountry US" {
  run "${clicmd}" wificountry US
  assert_success && assert_output -p 'country has been set'
}

@test "$clinom wificountry foo (invalid country code)" {
  run "${clicmd}" wificountry foo
  assert_output -p 'invalid country code'
}

@test "$clinom wificountry us (lower case country code)" {
  run "${clicmd}" wificountry us
  assert_success && assert_output -p 'country has been set'
}
