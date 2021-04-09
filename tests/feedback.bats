#!/usr/bin/env bats
load test-helper

@test "$clinom feedback" {
  run "${clicmd}" feedback
  assert_success && assert_output --partial 'No feedback was submitted.'
}

@test "$clinom feedback 'test from tests/feedback.bats'" {
  run "${clicmd}" feedback
  assert_output --partial 'Thanks for the feedback!'
}
