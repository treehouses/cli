#!/usr/bin/env bats
load test-helper

@test "$clinom locale (no argument)" {
  run "${clicmd}" locale
  assert_output -p 'locale is missing'
}

@test "$clinom locale en_US" {
  run "${clicmd}" locale en_US
  assert_success && assert_output -p 'locale has been changed'
}

@test "$clinom locale (non-supported locale)" {
  run "${clicmd}" locale no_NO
  assert_output -p 'is not supported'
}