#!/usr/bin/env bats
load test-helper

@test "$clinom remote status" {
  run "${clicmd}" remote status
  assert_success
}

@test "$clinom remote statuspage" {
  run "${clicmd}" remote statuspage
  assert_success
}

@test "$clinom remote upgrade" {
  run "${clicmd}" remote upgrade
  assert_success
}

@test "$clinom remote services available" {
  run "${clicmd}" remote services available
  assert_success
}

@test "$clinom remote version 2060" {
  run "${clicmd}" remote version 2060
  assert_success
}

@test "$clinom remote commands" {
  run "${clicmd}" remote commands
  assert_success

@test "$clinom remote commands json" {
  run "${clicmd}" remote commands json
  assert_success
}
