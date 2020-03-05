#!/usr/bin/env bats
load test-helper

@test "/cli.sh " {
  run ${CLICMD}
  assert_success
  assert_output -p 'Usage: cli.sh'
}
