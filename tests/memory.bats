#!/usr/bin/env bats
load test-helper

@test "$clinom memory" {
  run "${clicmd}" memory
  assert_success && assert_output -p 'Your rpi'
}

@test "$clinom memory -g" {
  run "${clicmd}" memory -g
  assert_success && assert_output -p 'Your rpi'
}

@test "$clinom memory total" {
  run "${clicmd}" memory total
  assert_success
}

@test "$clinom memory used" {
  run "${clicmd}" memory used
  assert_success
}

@test "$clinom memory free -m" {
  run "${clicmd}" memory free -m
  assert_success
}