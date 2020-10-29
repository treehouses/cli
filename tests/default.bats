#!/usr/bin/env bats
load test-helper

@test "$clinom default" {
  run "${clicmd}" default
  assert_success && assert_output -p 'Success'
}

@test "$clinom default network" {
  run "${clicmd}" default network
  assert_success && assert_output -p 'Success'
}

@test "$clinom default tunnel" {
  run "${clicmd}" default tunnel
  assert_success && assert_output -p 'Success'
}

@test "$clinom default notice" {
  run "${clicmd}" default notice
  assert_success && assert_output -p 'Success'
}