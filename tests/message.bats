#!/usr/bin/env bats
load test-helper

@test "$clinom message slack apitoken" {
  run "${clicmd}" message slack apitoken
  assert_success
}

@test "$clinom message slack apitoken [token]" {
  run "${clicmd}" message slack apitoken xoxp-fake-token
  assert_success
  treehouses config clear
}

REM Needs to 'store' previous tokens and re-add them
@test "$clinom message slack apitoken (no token)" {
  treehouses config clear
  run "${clicmd}" message slack apitoken
  assert_success
}

@test "$clinom message slack apitoken (with token)" {
  run "${clicmd}" message slack apitoken xoxp-fake-token
  run "${clicmd}" message slack apitoken
  assert_success
  treehouses config clear
}

@test "$clinom message slack apitoken [token]" {
  run "${clicmd}" message slack apitoken xoxp-fake-token
  assert_success
  treehouses config clear
}

@test "$clinom message slack apitoken [token]" {
  treehouses config clear
  run "${clicmd}" message slack apitoken fake-token
  assert_failure
  treehouses config clear
}
