#!/usr/bin/env bats
load ../test-helper

@test "$clinom services moodle info" {
  run "${clicmd}" services moodle info
  assert_success && assert_output -p 'https://github.com/treehouses/moodole'
}

@test "$clinom services moodle install" {
  run "${clicmd}" services moodle install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services moodle up" {
  run "${clicmd}" services moodle up
  sleep 5
  assert_success && assert_output -p 'moodle built and started'
}

@test "$clinom services moodle restart" {
  run "${clicmd}" services moodle restart
  sleep 5
  assert_success && assert_output -p 'moodle built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'moodle'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'moodle'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/moodle'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'moodle'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/moodle'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services moodle port" {
  run "${clicmd}" services moodle port
  assert_success && assert_output -p '8082'
}

@test "$clinom services moodle ps" {
  run "${clicmd}" services moodle ps
  assert_success && assert_output -p 'treehouses/moodle'
}

@test "$clinom services moodle url" {
  run "${clicmd}" services moodle url
  assert_output -p '80'
}

@test "$clinom services moodle autorun" {
  run "${clicmd}" services moodle autorun
  assert_success
}

@test "$clinom services moodle autorun true" {
  run "${clicmd}" services moodle autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services moodle stop" {
  run "${clicmd}" services moodle stop
  assert_success && assert_output -p 'moodle stopped'
}

@test "$clinom services moodle start" {
  run "${clicmd}" services moodle start
  assert_success && assert_output -p 'moodle started'
}

@test "$clinom services moodle down" {
  run "${clicmd}" services moodle down
  assert_success && assert_output -p 'moodle stopped and removed'
}

@test "$clinom services moodle icon" {
  run "${clicmd}" services moodle icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services moodle cleanup" {
  run "${clicmd}" services moodle cleanup
  assert_success && assert_output -p 'cleaned up'
}
