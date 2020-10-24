#!/usr/bin/env bats
load ../test-helper

@test "$clinom services tutor info" {
  run "${clicmd}" services tutor info
  assert_success && assert_output -p 'https://github.com/edx/edx-platform'
}

@test "$clinom services tutor install" {
  run "${clicmd}" services tutor install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services tutor up" {
  run "${clicmd}" services tutor up
  sleep 5
  assert_success && assert_output -p 'tutor built and started'
}

@test "$clinom services tutor restart" {
  run "${clicmd}" services tutor restart
  sleep 5
  assert_success && assert_output -p 'tutor built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'tutor'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'tutor'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'hirotochigi/openedx:10.0.10'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'tutor'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'hirotochigi/openedx:10.0.10'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services tutor port" {
  run "${clicmd}" services tutor port
  assert_success && assert_output -p '8090'
}

@test "$clinom services tutor ps" {
  run "${clicmd}" services tutor ps
  assert_success && assert_output -p 'hirotochigi/openedx:10.0.10'
}

@test "$clinom services tutor url" {
  run "${clicmd}" services tutor url
  assert_output -p '8090'
}

@test "$clinom services tutor autorun" {
  run "${clicmd}" services tutor autorun
  assert_success
}

@test "$clinom services tutor autorun true" {
  run "${clicmd}" services tutor autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services tutor stop" {
  run "${clicmd}" services tutor stop
  assert_success && assert_output -p 'tutor stopped'
}

@test "$clinom services tutor start" {
  run "${clicmd}" services tutor start
  assert_success && assert_output -p 'tutor started'
}

@test "$clinom services tutor down" {
  run "${clicmd}" services tutor down
  assert_success && assert_output -p 'tutor stopped and removed'
}

@test "$clinom services tutor icon" {
  run "${clicmd}" services tutor icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services tutor cleanup" {
  run "${clicmd}" services tutor cleanup
  assert_success && assert_output -p 'cleaned up'
}
