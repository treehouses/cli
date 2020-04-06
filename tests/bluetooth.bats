#!/usr/bin/env bats
load test-helper

@test "$clinom bluetooth off" {
  run "${clicmd}" bluetooth off
  assert_success && assert_output -p 'has been stopped'
}

@test "$clinom bluetooth pause" {
  run "${clicmd}" bluetooth pause
  assert_success && assert_output -p 'has been stopped'
}

@test "$clinom bluetooth on" {
  run "${clicmd}" bluetooth on
  assert_success && assert_output -p 'has been started'
}

@test "$clinom bluetooth mac" {
  run "${clicmd}" bluetooth mac
  assert_success
}

@test "$clinom bluetooth id" {
  run "${clicmd}" bluetooth id
  assert_success
}

@test "$clinom bluetooth id number" {
  run "${clicmd}" bluetooth id number
  assert_success
}
