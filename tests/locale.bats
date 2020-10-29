#!/usr/bin/env bats
load test-helper

@test "$clinom locale en_US" {
  run "${clicmd}" locale en_US
  assert_success && assert_output -p 'locale has been changed'
}