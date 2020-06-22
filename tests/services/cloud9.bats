#!/usr/bin/env bats
load ../test-helper

@test "$clinom services cloud9 info" {
  run "${clicmd}" services cloud9 info
  assert_success && assert_output -p 'https://github.com/linuxserver/docker-cloud9.git'
}

@test "$clinom services cloud9 install" {
  run "${clicmd}" services cloud9 install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services cloud9 up" {
  run "${clicmd}" services cloud9 up
  sleep 5
  assert_success && assert_output -p 'cloud9 built and started'
}

@test "$clinom services cloud9 restart" {
  run "${clicmd}" services cloud9 restart
  sleep 5
  assert_success && assert_output -p 'cloud9 built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'cloud9'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'cloud9'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/cloud9'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'cloud9'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/cloud9'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services cloud9 port" {
  run "${clicmd}" services cloud9 port
  assert_success && assert_output -p '9999'
}

@test "$clinom services cloud9 ps" {
  run "${clicmd}" services cloud9 ps
  assert_success && assert_output -p 'linuxserver/cloud9'
}

@test "$clinom services cloud9 url" {
  run "${clicmd}" services cloud9 url
  assert_output -p '9999'
}

@test "$clinom services cloud9 autorun" {
  run "${clicmd}" services cloud9 autorun
  assert_success
}

@test "$clinom services cloud9 autorun true" {
  run "${clicmd}" services cloud9 autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services cloud9 stop" {
  run "${clicmd}" services cloud9 stop
  assert_success && assert_output -p 'cloud9 stopped'
}

@test "$clinom services cloud9 start" {
  run "${clicmd}" services cloud9 start
  assert_success && assert_output -p 'cloud9 started'
}

@test "$clinom services cloud9 down" {
  run "${clicmd}" services cloud9 down
  assert_success && assert_output -p 'cloud9 stopped and removed'
}

@test "$clinom services cloud9 icon" {
  run "${clicmd}" services cloud9 icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services cloud9 cleanup" {
  run "${clicmd}" services cloud9 cleanup
  assert_success && assert_output -p 'cleaned up'
}
