#!/usr/bin/env bats
load test-helper

@test "$clinom image" {
  run "${clicmd}" image
  assert_success && assert_output -p 'release-'
}

@test "$clinom image (too many arguments)" {
  run "${clicmd}" image foobar
  assert_failure && assert_output -p 'Too many arguments.'
}