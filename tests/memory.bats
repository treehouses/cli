#!/usr/bin/env bats
load test-helper

@test "$clinom memory" {
  run "${clicmd}" memory
  assert_success && assert_output -p 'Your rpi'
}

@test "$clinom memory gb" {
  run "${clicmd}" memory gb
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

@test "$clinom memory free mb" {
  run "${clicmd}" memory free mb
  assert_success
}