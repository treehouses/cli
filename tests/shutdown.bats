#!/usr/bin/env bats
load test-helper

@test "$clinom shutdown" { # Needs to do ctrl+c
  run "${clicmd}" shutdown
  assert_success && assert_output -p 'Shutting down in 60 seconds. Press ctrl+c to cancel.'
}
