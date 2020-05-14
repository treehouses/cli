#!/usr/bin/env bats
load ../test-helper

@test "$clinom services netdata info" {
  run "${clicmd}" services netdata info
  assert_success && assert_output -p 'https://github.com/netdata/netdata'
}

@test "$clinom services netdata install" {
  run "${clicmd}" services netdata install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services netdata up" {
  run "${clicmd}" services netdata up
  sleep 5
  assert_success && assert_output -p 'netdata built and started'
}

@test "$clinom services netdata restart" {
  run "${clicmd}" services netdata restart
  sleep 5
  assert_success && assert_output -p 'netdata built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'netdata'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'netdata'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'netdata/netdata'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'netdata'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'netdata/netdata'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services netdata port" {
  run "${clicmd}" services netdata port
  assert_success && assert_output -p '19999'
}

@test "$clinom services netdata ps" {
  run "${clicmd}" services netdata ps
  assert_success && assert_output -p 'netdata/netdata'
}

@test "$clinom services netdata url" {
  run "${clicmd}" services netdata url
  assert_output -p '19999'
}

@test "$clinom services netdata autorun" {
  run "${clicmd}" services netdata autorun
  assert_success
}

@test "$clinom services netdata autorun true" {
  run "${clicmd}" services netdata autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services netdata stop" {
  run "${clicmd}" services netdata stop
  assert_success && assert_output -p 'netdata stopped'
}

@test "$clinom services netdata start" {
  run "${clicmd}" services netdata start
  assert_success && assert_output -p 'netdata started'
}

@test "$clinom services netdata down" {
  run "${clicmd}" services netdata down
  assert_success && assert_output -p 'netdata stopped and removed'
}

@test "$clinom services netdata icon" {
  run "${clicmd}" services netdata icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services netdata cleanup" {
  run "${clicmd}" services netdata cleanup
  assert_success && assert_output -p 'cleaned up'
}
