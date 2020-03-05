#!/usr/bin/env bats
load test-helper

@test "/cli.sh " {
  run ${clicmd}
  assert_success
  assert_output -p 'Usage: cli.sh'
}
