#!/usr/bin/env bats
load test-helper

@test "$clinom config (empty)" {
  run "${clicmd}" config clear
  run "${clicmd}" config
  assert_output --partial 'config file is empty'
}

@test "$clinom config (random subcommand)" {
  run "${clicmd}" config random-command
  assert_output --partial 'options are supported'
}

@test "$clinom config (not empty)" {
  run "${clicmd}" config add slack_apitoken xoxp-0000000000000-1111111111111-2222222222222
  run "${clicmd}" config
  assert_success
}

@test "$clinom config update" {
  run "${clicmd}" config update slack_apitoken xoxp-0000000000000-1111111111111-2222222222222
  assert_success
}

@test "$clinom config add" {
  run "${clicmd}" config add slack_apitoken xoxp-0000000000000-1111111111111-2222222222222
  assert_success
}

@test "$clinom config add (missing argument)" {
  run "${clicmd}" config add
  assert_output --partial 'missing varname or varvalue'
}

@test "$clinom config delete" {
  run "${clicmd}" config delete slack_apitoken
  assert_failure
}

@test "$clinom config delete (non-existent user)" {
  run "${clicmd}" config delete slack_apitoken
  assert_output --partial "doesn't exist"
}

@test "$clinom config clear" {
  run "${clicmd}" config clear
  [ ! -e /etc/treehouses.conf ]
  assert_success
}