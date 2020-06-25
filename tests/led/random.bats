#!/usr/bin/env bats
load ../test-helper

@test "$clinom led random" {
  run "${clicmd}" led random
  assert_success
}
