#!/usr/bin/env bats
load test-helper

@test "$clinom feedback (no feedback)" {
  run "${clicmd}" feedback
  assert_success && assert_output --partial 'No feedback was submitted.'
}

@test "$clinom feedback foo (with feedback)" {
  run "${clicmd}" feedback "test from tests/feedback.bats"
  assert_output --partial 'Thanks for the feedback!'
}
