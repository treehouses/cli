#!/usr/bin/env bats
load test-helper

@test "$clinom" {
  run ${clicmd}
  assert_success
  assert_output -p 'Usage: cli.sh'
}
