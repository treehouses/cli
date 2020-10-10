#!/usr/bin/env bats
load test-helper

@test "$clinom verbose" {
  run "${clicmd}" verbose
  assert_success && assert_output -p 'Verbosity is'
}

@test "$clinom verbose on" {
  run "${clicmd}" verbose on
  assert_success && assert_output -p 'enabled'
}

@test "$clinom verbose off" {
  run "${clicmd}" verbose off
  assert_success && assert_output -p 'disabled'
}