#!/usr/bin/env bats
load test-helper

@test "$clinom led eid" {
  run "${clicmd}" led eid
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led wazazi" {
  run "${clicmd}" led wazazi
  assert_success && assert_output -p 'heartbeat' 
}

@test "$clinom led onam" {
  run "${clicmd}" led onam
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led diwali" {
  run "${clicmd}" led diwali
  assert_success && assert_output -p 'heartbeat'
}

@test "$clinom led thanksgiving" {
  run "${clicmd}" led thanksgiving
  assert_success && assert_output -p 'heartbeat'
}


