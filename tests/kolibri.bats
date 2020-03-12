#!/usr/bin/env bats
load test-helper

@test "$clinom services kolibri info" {
  run "${clicmd}" services kolibri info
  assert_success && assert_output -p 'https://github.com/treehouses/kolibri'
}

@test "$clinom services kolibri install" {
  run "${clicmd}" services kolibri install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services kolibri up" {
  run "${clicmd}" services kolibri up
  sleep 5
  assert_success && assert_output -p 'kolibri built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'kolibri'
}

@test "$clinom services available full" {
  run "${clicmd}" services available full
  assert_success && assert_output -p 'kolibri'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'kolibri'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/kolibri'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'kolibri'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/kolibri'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services kolibri port" {
  run "${clicmd}" services kolibri port
  assert_success && assert_output -p '8080'
}

@test "$clinom services kolibri ps" {
  run "${clicmd}" services kolibri ps
  assert_success && assert_output -p 'treehouses/kolibri'
}

@test "$clinom services kolibri url both" {
  run "${clicmd}" services kolibri url both
  assert_output -p '8080'
}

@test "$clinom services kolibri autorun" {
  run "${clicmd}" services kolibri autorun
  assert_success
}

@test "$clinom services kolibri autorun true" {
  run "${clicmd}" services kolibri autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services kolibri stop" {
  run "${clicmd}" services kolibri stop
  assert_success && assert_output -p 'kolibri stopped'
}

@test "$clinom services kolibri down" {
  run "${clicmd}" services kolibri down
  assert_success && assert_output -p 'kolibri stopped and removed'
}

@test "$clinom services kolibri cleanup" {
  run "${clicmd}" services kolibri cleanup
  assert_success && assert_output -p 'cleaned up'
}
