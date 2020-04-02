#!/usr/bin/env bats
load test-helper

@test "$clinom ntp internet" {
  run "${clicmd}" ntp internet
  assert_success && assert_output -p 'Success'
}

@test "$clinom ntp local" {
  run "${clicmd}" ntp local
  assert_success && assert_output -p 'Success'
}
