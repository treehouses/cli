#!/usr/bin/env bats
load test-helper

@test "$clinom sdbench" {
  run "${clicmd}" sdbench
  assert_success && assert_output -p 'read' && assert_output -p 'write'
}

@test "$clinom sdbench (added extra arguments)" {
  run "${clicmd}" sdbench foobar
  assert_failure && assert_output -p 'Too many arguments.'
}