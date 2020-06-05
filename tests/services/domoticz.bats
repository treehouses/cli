#!/usr/bin/env bats
load ../test-helper

@test "$clinom services domoticz info" {
  run "${clicmd}" services domoticz info
  assert_success && assert_output -p 'https://github.com/domoticz/domoticz'
}

@test "$clinom services domoticz install" {
  run "${clicmd}" services domoticz install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services domoticz up" {
  run "${clicmd}" services domoticz up
  sleep 5
  assert_success && assert_output -p 'domoticz built and started'
}

@test "$clinom services domoticz restart" {
  run "${clicmd}" services domoticz restart
  sleep 5
  assert_success && assert_output -p 'domoticz built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'domoticz'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'domoticz'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/domoticz'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'domoticz'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/domoticz'
}

@test "$clinom services domoticz port" {
  run "${clicmd}" services domoticz port
  assert_success && assert_output -p ''
}

@test "$clinom services domoticz ps" {
  run "${clicmd}" services domoticz ps
  assert_success && assert_output -p 'linuxserver/domoticz'
}

@test "$clinom services domoticz url" {
  run "${clicmd}" services domoticz url
  assert_output -p '6144'
}

@test "$clinom services domoticz autorun" {
  run "${clicmd}" services domoticz autorun
  assert_success
}

@test "$clinom services domoticz autorun true" {
  run "${clicmd}" services domoticz autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services domoticz stop" {
  run "${clicmd}" services domoticz stop
  assert_success && assert_output -p 'domoticz stopped'
}

@test "$clinom services domoticz start" {
  run "${clicmd}" services domoticz start
  assert_success
}

@test "$clinom services domoticz down" {
  run "${clicmd}" services domoticz down
  assert_success && assert_output -p 'domoticz stopped and removed'
}

@test "$clinom services domoticz icon" {
  run "${clicmd}" services domoticz icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services domoticz cleanup" {
  run "${clicmd}" services domoticz cleanup
  assert_success && assert_output -p 'cleaned up'
}
