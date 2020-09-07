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

@test "$clinom vnc auth system" {
  run "${clicmd}" vnc info
  assert_success && assert_output -p 'system'
}

@test "$clinom vnc auth vncpasswd" {
  run "${clicmd}" vnc auth vncpasswd
  assert_success && assert_output -p 'password'
}

@test "$clinom vnc auth info" {
  run "${clicmd}" vnc auth info
  assert_success && assert_output -p 'authentication'
}