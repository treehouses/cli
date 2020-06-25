#!/usr/bin/env bats
load ../test-helper

@test "$clinom led newyear" {
  run "${clicmd}" led newyear
  assert_success && assert_output -p 'default'
}
