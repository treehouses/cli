#!/usr/bin/env bats
load test-helper

@test "$clinom blocker" {
  run "${clicmd}" blocker
  assert_success && assert_output -p 'blocker is'
}

@test "$clinom blocker max" {
  run "${clicmd}" blocker max
  assert_success && assert_output -p 'blocker X'
}

@test "$clinom blocker 4" {
  run "${clicmd}" blocker 4
  assert_success && assert_output -p 'blocker 4'
}

@test "$clinom blocker 3" {
  run "${clicmd}" blocker 3
  assert_success && assert_output -p 'blocker 3'
}

@test "$clinom blocker 2" {
  run "${clicmd}" blocker 2
  assert_success && assert_output -p 'blocker 2'
}

@test "$clinom blocker 1" {
  run "${clicmd}" blocker 1
  assert_success && assert_output -p 'blocker 1'
}

@test "$clinom blocker 0" {
  run "${clicmd}" blocker 0
  assert_success && assert_output -p 'blocker 0'
}
