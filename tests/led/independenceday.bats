#!/usr/bin/env bats
load ../test-helper

@test "$clinom led independenceday" {
  run "${clicmd}" led independenceday
  assert_success && assert_output -p 'heartbeat'
}