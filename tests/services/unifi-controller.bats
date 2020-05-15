#!/usr/bin/env bats
load ../test-helper

@test "$clinom services unifi-controller info" {
  run "${clicmd}" services unifi-controller info
  assert_success && assert_output -p 'https://www.ubnt.com/enterprise/#unifi'
}

@test "$clinom services unifi-controller install" {
  run "${clicmd}" services unifi-controller install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services unifi-controller up" {
  run "${clicmd}" services unifi-controller up
  sleep 5
  assert_success && assert_output -p 'unifi-controller built and started'
}

@test "$clinom services unifi-controller restart" {
  run "${clicmd}" services unifi-controller restart
  sleep 5
  assert_success && assert_output -p 'unifi-controller built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'unifi-controller'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'unifi-controller'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/unifi-controller'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'unifi-controller'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/unifi-controller'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services unifi-controller port" {
  run "${clicmd}" services unifi-controller port
  assert_success && assert_output -p '10002'
}

@test "$clinom services unifi-controller ps" {
  run "${clicmd}" services unifi-controller ps
  assert_success && assert_output -p 'linuxserver/unifi-controller'
}

@test "$clinom services unifi-controller url" {
  run "${clicmd}" services unifi-controller url
  assert_output -p '10002'
}

@test "$clinom services unifi-controller autorun" {
  run "${clicmd}" services unifi-controller autorun
  assert_success
}

@test "$clinom services unifi-controller autorun true" {
  run "${clicmd}" services unifi-controller autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services unifi-controller stop" {
  run "${clicmd}" services unifi-controller stop
  assert_success && assert_output -p 'unifi-controller stopped'
}

@test "$clinom services unifi-controller down" {
  run "${clicmd}" services unifi-controller down
  assert_success && assert_output -p 'unifi-controller stopped and removed'
}

@test "$clinom services unifi-controller icon" {
  run "${clicmd}" services unifi-controller icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services unifi-controller cleanup" {
  run "${clicmd}" services unifi-controller cleanup
  assert_success && assert_output -p 'cleaned up'
}
