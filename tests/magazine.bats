#!/usr/bin/env bats
load test-helper

@test "$clinom magazine magpi" {
  run "${clicmd}" magazine magpi
  assert_success
}

@test "$clinom magazine magpi latest" {
  run "${clicmd}" magazine magpi latest
  assert_output -p 'MagPi93.pdf already exists, exiting...'
}

@test "$clinom magazine magpi all" {
  run "${clicmd}" magazine magpi all
  assert_success
}
