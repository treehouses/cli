#!/usr/bin/env bats
load ../test-helper

@test "$clinom services unifi info" {
  run "../${clicmd}" services unifi info
  assert_success && assert_output -p 'https://www.ubnt.com/enterprise/#unifi'
}

@test "$clinom services unifi install" {
  run "../${clicmd}" services unifi install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services unifi up" {
  run "../${clicmd}" services unifi up
  sleep 5
  assert_success && assert_output -p 'unifi built and started'
}

@test "$clinom services unifi start" {
  run "../${clicmd}" services unifi start
  sleep 5
  assert_success && assert_output -p 'unifi started'
}

@test "$clinom services unifi restart" {
  run "../${clicmd}" services unifi restart
  sleep 5
  assert_success && assert_output -p 'unifi built and started'
}

@test "$clinom services available" {
  run "../${clicmd}" services available
  assert_success && assert_output -p 'unifi'
}

@test "$clinom services running" {
  run "../${clicmd}" services running
  assert_success && assert_output -p 'unifi'
}

@test "$clinom services running full" {
  run "../${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/unifi'
}

@test "$clinom services installed" {
  run "../${clicmd}" services installed
  assert_success && assert_output -p 'unifi'
}

@test "$clinom services installed full" {
  run "../${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/unifi'
}

@test "$clinom services ports" {
  run "../${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services unifi port" {
  run "../${clicmd}" services unifi port
  assert_success && assert_output -p '8443'
}

@test "$clinom services unifi ps" {
  run "../${clicmd}" services unifi ps
  assert_success && assert_output -p 'linuxserver/unifi'
}

@test "$clinom services unifi url" {
  run "../${clicmd}" services unifi url
  assert_output -p '8443'
}

@test "$clinom services unifi autorun" {
  run "../${clicmd}" services unifi autorun
  assert_success
}

@test "$clinom services unifi autorun true" {
  run "../${clicmd}" services unifi autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services unifi stop" {
  run "../${clicmd}" services unifi stop
  assert_success && assert_output -p 'unifi stopped'
}

@test "$clinom services unifi down" {
  run "../${clicmd}" services unifi down
  assert_success && assert_output -p 'unifi stopped and removed'
}

@test "$clinom services unifi icon" {
  run "../${clicmd}" services unifi icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services unifi cleanup" {
  run "../${clicmd}" services unifi cleanup
  assert_success && assert_output -p 'cleaned up'
}
