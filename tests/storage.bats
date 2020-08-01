#!/usr/bin/env bats
load test-helper

@test "$clinom storage gb" {
  run "${clicmd}" storage gb
  assert_success && assert_output -p 'Your rpi'
}

@test "$clinom storage kb" {
  run "${clicmd}" storage
  assert_success && assert_output -p 'Your rpi'
}

@test "$clinom storage total" {
  run "${clicmd}" storage total
  assert_success
}

@test "$clinom storage used" {
  run "${clicmd}" storage used
  assert_success
}

@test "$clinom storage used kb" {
  run "${clicmd}" storage used kb
  assert_success
}

@test "$clinom storage free mb" {
  run "${clicmd}" storage free mb
  assert_success
}