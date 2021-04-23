#!/usr/bin/env bats
load test-helper

@test "$clinom internet" {
  run "${clicmd}" internet
  assert_success && assert_output -p 'true'
}

@test "$clinom internet (invalid argument)" {
  run "${clicmd}" internet foobar
  assert_failure && assert_output -p 'incorrect command'
}

@test "$clinom internet reverse" {
  run "${clicmd}" internet reverse
  assert_success
}

@test "$clinom internet reverse (too many arguments)" {
  run "${clicmd}" internet reverse foobar
  assert_failure && assert_output -p 'Too many arguments'
}