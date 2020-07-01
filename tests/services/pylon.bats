#!/usr/bin/env bats
load ../test-helper

@test "$clinom services pylon info" {
  run "${clicmd}" services pylon info
  assert_success && assert_output -p 'https://github.com/linuxserver/docker-pylon.git'
}

@test "$clinom services pylon install" {
  run "${clicmd}" services pylon install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services pylon up" {
  run "${clicmd}" services pylon up
  sleep 5
  assert_success && assert_output -p 'pylon built and started'
}

@test "$clinom services pylon restart" {
  run "${clicmd}" services pylon restart
  sleep 5
  assert_success && assert_output -p 'pylon built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'pylon'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'pylon'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/pylon'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'pylon'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/pylon'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 8094'
}

@test "$clinom services pylon port" {
  run "${clicmd}" services pylon port
  assert_success && assert_output -p '8094'
}

@test "$clinom services pylon ps" {
  run "${clicmd}" services pylon ps
  assert_success && assert_output -p 'linuxserver/pylon'
}

@test "$clinom services pylon url" {
  run "${clicmd}" services pylon url
  assert_output -p '8094'
}

@test "$clinom services pylon autorun" {
  run "${clicmd}" services pylon autorun
  assert_success
}

@test "$clinom services pylon autorun true" {
  run "${clicmd}" services pylon autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services pylon stop" {
  run "${clicmd}" services pylon stop
  assert_success && assert_output -p 'pylon stopped'
}

@test "$clinom services pylon start" {
  run "${clicmd}" services pylon start
  assert_success && assert_output -p 'pylon started'
}

@test "$clinom services pylon down" {
  run "${clicmd}" services pylon down
  assert_success && assert_output -p 'pylon stopped and removed'
}

@test "$clinom services pylon icon" {
  run "${clicmd}" services pylon icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services pylon cleanup" {
  run "${clicmd}" services pylon cleanup
  assert_success && assert_output -p 'cleaned up'
}
