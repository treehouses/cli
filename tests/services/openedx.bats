#!/usr/bin/env bats
load ../test-helper

@test "$clinom services openedx info" {
  run "${clicmd}" services openedx info
  assert_success && assert_output -p 'https://github.com/edx/edx-platform'
}

@test "$clinom services openedx install" {
  run "${clicmd}" services openedx install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services openedx up" {
  run "${clicmd}" services openedx up
  sleep 5
  assert_success && assert_output -p 'openedx built and started'
}

@test "$clinom services openedx restart" {
  run "${clicmd}" services openedx restart
  sleep 5
  assert_success && assert_output -p 'openedx restart'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'openedx'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'openedx'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'hirotochigi/openedx:10.0.10'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'openedx'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'hirotochigi/openedx:10.0.10'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services openedx port" {
  run "${clicmd}" services openedx port
  assert_success && assert_output -p '8098'
}

@test "$clinom services openedx ps" {
  run "${clicmd}" services openedx ps
  assert_success && assert_output -p 'hirotochigi/openedx:10.0.10'
}

@test "$clinom services openedx url" {
  run "${clicmd}" services openedx url
  assert_output -p '8098'
}

@test "$clinom services openedx autorun" {
  run "${clicmd}" services openedx autorun
  assert_success
}

@test "$clinom services openedx autorun true" {
  run "${clicmd}" services openedx autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services openedx stop" {
  run "${clicmd}" services openedx stop
  assert_success && assert_output -p 'openedx stopped'
}

@test "$clinom services openedx start" {
  run "${clicmd}" services openedx start
  assert_success && assert_output -p 'openedx started'
}

@test "$clinom services openedx down" {
  run "${clicmd}" services openedx down
  assert_success && assert_output -p 'openedx stopped and removed'
}

@test "$clinom services openedx icon" {
  run "${clicmd}" services openedx icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services openedx cleanup" {
  run "${clicmd}" services openedx cleanup
  assert_success && assert_output -p 'cleaned up'
}
