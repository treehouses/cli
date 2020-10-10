#!/usr/bin/env bats
load ../test-helper

@test "$clinom services mastodon info" {
  run "${clicmd}" services mastodon info
  assert_success && assert_output -p 'https://github.com/gilir/rpi-mastodon'
}

@test "$clinom services mastodon install" {
  run "${clicmd}" services mastodon install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services mastodon up" {
  run "${clicmd}" services mastodon up
  sleep 5
  assert_success && assert_output -p 'mastodon built and started'
}

@test "$clinom services mastodon restart" {
  run "${clicmd}" services mastodon restart
  sleep 5
  assert_success && assert_output -p 'mastodon built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'mastodon'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'mastodon'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'gilir/rpi-mastodon'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'mastodon'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'gilir/rpi-mastodon'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services mastodon port" {
  run "${clicmd}" services mastodon port
  assert_success && assert_output -p '3000'
}

@test "$clinom services mastodon ps" {
  run "${clicmd}" services mastodon ps
  assert_success && assert_output -p 'gilir/rpi-mastodon'
}

@test "$clinom services mastodon url" {
  run "${clicmd}" services mastodon url
  assert_output -p '3000'
}

@test "$clinom services mastodon autorun" {
  run "${clicmd}" services mastodon autorun
  assert_success
}

@test "$clinom services mastodon autorun true" {
  run "${clicmd}" services mastodon autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services mastodon stop" {
  run "${clicmd}" services mastodon stop
  assert_success && assert_output -p 'mastodon stopped'
}

@test "$clinom services mastodon start" {
  run "${clicmd}" services mastodon start
  assert_success && assert_output -p 'mastodon started'
}

@test "$clinom services mastodon down" {
  run "${clicmd}" services mastodon down
  assert_success && assert_output -p 'mastodon stopped and removed'
}

@test "$clinom services mastodon icon" {
  run "${clicmd}" services mastodon icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services mastodon cleanup" {
  run "${clicmd}" services mastodon cleanup
  assert_success && assert_output -p 'cleaned up'
}
