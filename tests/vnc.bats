#!/usr/bin/env bats
load test-helper

@test "$clinom vnc" {
  run "${clicmd}" vnc
  assert_success
}

@test "$clinom vnc off" {
  run "${clicmd}" vnc off
  assert_success && assert_output -p 'disabled'
}

@test "$clinom vnc on" {
  run "${clicmd}" vnc on
  assert_success && assert_output -p 'enabled'
}

@test "$clinom vnc info" {
  run "${clicmd}" vnc info
  assert_success
}