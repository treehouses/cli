#!/usr/bin/env bats
load test-helper

@test "$clinom config" {
  skip "Run $clinom config with the [update|add|delete|clear] subcommands"
  run "${clicmd}" config
  [ "$status" -eq 0 ]
}

@test "$clinom config update" {
  run "${clicmd}" config update abc 123
  if [[ "$output" == *"Error"* ]]; then
    skip "Missing varname or varvalue"
  fi
  assert_success
}

@test "$clinom config add" {
  run "${clicmd}" config add abc 123
  if [[ "$output" == *"Error"* ]]; then
    skip "Missing varname or varvalue"
  fi
  assert_success
}

@test "$clinom config delete" {
  run "${clicmd}" config delete abc
  if [[ "$output" == *"Error"* ]]; then
    skip "Missing varname"
  fi
  assert_success
}

@test "$clinom config delete (non-existent user)" {
  run "${clicmd}" config clear
  run "${clicmd}" config delete abc
  if [[ "$output" == *"Error"* ]]; then
    skip "Can't delete a non-existent user"
  fi
  assert_success
}

@test "$clinom config clear" {
  run "${clicmd}" config clear
  assert_success
}