#!/usr/bin/env bats
load test-helper

@test "$clinom bootoption console" {
  run "${clicmd}" bootoption console
  assert_success && assert_output -p 'OK'
}

@test "$clinom bootoption console autologin" {
  run "${clicmd}" bootoption console autologin
  assert_success && assert_output -p 'OK'
}

@test "$clinom bootoption desktop" {
  run "${clicmd}" bootoption desktop
  assert_success && assert_output -p 'OK'
}

@test "$clinom bootoption desktop autologin" {
  run "${clicmd}" bootoption desktop autologin
  assert_success && assert_output -p 'OK'
}