#!/usr/bin/env bats
load ../test-helper

@test "$clinom services piwigo info" {
  run "${clicmd}" services piwigo info
  assert_success && assert_output -p 'https://github.com/linuxserver/docker-piwigo'
}

@test "$clinom services piwigo install" {
  run "${clicmd}" services piwigo install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services piwigo up" {
  run "${clicmd}" services piwigo up
  sleep 5
  assert_success && assert_output -p 'piwigo built and started'
}

@test "$clinom services piwigo start" {
  run "${clicmd}" services piwigo start
  sleep 5
  assert_success && assert_output -p 'piwigo started'
}

@test "$clinom services piwigo restart" {
  run "${clicmd}" services piwigo restart
  sleep 5
  assert_success && assert_output -p 'piwigo built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'piwigo'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'piwigo'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/piwigo'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'piwigo'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/piwigo'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 8094'
}

@test "$clinom services piwigo port" {
  run "${clicmd}" services piwigo port
  assert_success && assert_output -p '8094'
}

@test "$clinom services piwigo ps" {
  run "${clicmd}" services piwigo ps
  assert_success && assert_output -p 'linuxserver/piwigo'
}

@test "$clinom services piwigo url" {
  run "${clicmd}" services piwigo url
  assert_output -p '8094'
}

@test "$clinom services piwigo autorun" {
  run "${clicmd}" services piwigo autorun
  assert_success
}

@test "$clinom services piwigo autorun true" {
  run "${clicmd}" services piwigo autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services piwigo stop" {
  run "${clicmd}" services piwigo stop
  assert_success && assert_output -p 'piwigo stopped'
}

@test "$clinom services piwigo down" {
  run "${clicmd}" services piwigo down
  assert_success && assert_output -p 'piwigo stopped and removed'
}

@test "$clinom services piwigo icon" {
  run "${clicmd}" services piwigo icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services piwigo cleanup" {
  run "${clicmd}" services piwigo cleanup
  assert_success && assert_output -p 'cleaned up'
}
