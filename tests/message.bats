#!/usr/bin/env bats
load test-helper

@test "$clinom message slack apitoken" {
  run "${clicmd}" message slack apitoken
  assert_success
}

@test "$clinom message slack apitoken [token]" {
  "${clicmd}" config delete xoxp-fake-token
  run "${clicmd}" message slack apitoken xoxp-fake-token
  assert_success
  "${clicmd}" config delete xoxp-fake-token
}

# Needs to 'store' previous tokens and re-add them
@test "$clinom message slack apitoken (no token)" {
  "${clicmd}" config clear
  run "${clicmd}" message slack apitoken
  assert_success
}

@test "$clinom message slack apitoken (with token)" {
  run "${clicmd}" message slack apitoken xoxp-fake-token
  run "${clicmd}" message slack apitoken
  assert_success
  "${clicmd}" config delete xoxp-fake-token
}

@test "$clinom message slack apitoken [token]" {
  run "${clicmd}" message slack apitoken xoxp-fake-token
  assert_success
  "${clicmd}" config delete xoxp-fake-token
}

@test "$clinom message slack apitoken [bad token]" {
  "${clicmd}" config clear
  run "${clicmd}" message slack apitoken fake-token
  assert_failure
  "${clicmd}" config delete fake-token
}

#debugging
@test "$clinom message slack apitoken [bad token]" {
  "${clicmd}" config clear
  run "${clicmd}" message slack apitoken fake-token
  assert_success
  "${clicmd}" config delete fake-token
}
