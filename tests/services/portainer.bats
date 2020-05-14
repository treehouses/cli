#!/usr/bin/env bats
load ../test-helper

@test "$clinom services portainer info" {
  run "${clicmd}" services portainer info
  assert_success && assert_output -p 'https://github.com/portainer/portainer'
}

@test "$clinom services portainer install" {
  run "${clicmd}" services portainer install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services portainer up" {
  run "${clicmd}" services portainer up
  sleep 5
  assert_success && assert_output -p 'portainer built and started'
}

@test "$clinom services portainer restart" {
  run "${clicmd}" services portainer restart
  sleep 5
  assert_success && assert_output -p 'portainer built and started'
}
@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'portainer'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'portainer'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'portainer/portainer'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'portainer'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'portainer/portainer'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services portainer port" {
  run "${clicmd}" services portainer port
  assert_success && assert_output -p '9000'
}

@test "$clinom services portainer ps" {
  run "${clicmd}" services portainer ps
  assert_success && assert_output -p 'portainer/portainer'
}

@test "$clinom services portainer url" {
  run "${clicmd}" services portainer url
  assert_output -p '9000'
}

@test "$clinom services portainer autorun" {
  run "${clicmd}" services portainer autorun
  assert_success
}

@test "$clinom services portainer autorun true" {
  run "${clicmd}" services portainer autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services portainer stop" {
  run "${clicmd}" services portainer stop
  assert_success && assert_output -p 'portainer stopped'
}

@test "$clinom services portainer start" {
  run "${clicmd}" services portainer start
  assert_success && assert_output -p 'portainer started'
}

@test "$clinom services portainer down" {
  run "${clicmd}" services portainer down
  assert_success && assert_output -p 'portainer stopped and removed'
}

@test "$clinom services portainer icon" {
  run "${clicmd}" services portainer icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services portainer cleanup" {
  run "${clicmd}" services portainer cleanup
  assert_success && assert_output -p 'cleaned up'
}
