#!/usr/bin/env bats
load ../test-helper

@test "$clinom services grocy info" {
  run "${clicmd}" services grocy info
  assert_success && assert_output -p 'https://github.com/linuxserver/docker-grocy'
}

@test "$clinom services grocy install" {
  run "${clicmd}" services grocy install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services grocy up" {
  run "${clicmd}" services grocy up
  sleep 5
  assert_success && assert_output -p 'grocy built and started'
}

@test "$clinom services grocy start" {
  run "${clicmd}" services grocy start
  sleep 5
  assert_success && assert_output -p 'grocy started'
}

@test "$clinom services grocy restart" {
  run "${clicmd}" services grocy restart
  sleep 5
  assert_success && assert_output -p 'grocy built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'grocy'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'grocy'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/grocy'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'grocy'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/grocy'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services grocy port" {
  run "${clicmd}" services grocy port
  assert_success && assert_output -p '8091'
}

@test "$clinom services grocy ps" {
  run "${clicmd}" services grocy ps
  assert_success && assert_output -p 'linuxserver/grocy'
}

@test "$clinom services grocy url" {
  run "${clicmd}" services grocy url
  assert_output -p '8091'
}

@test "$clinom services grocy autorun" {
  run "${clicmd}" services grocy autorun
  assert_success
}

@test "$clinom services grocy autorun true" {
  run "${clicmd}" services grocy autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services grocy stop" {
  run "${clicmd}" services grocy stop
  assert_success && assert_output -p 'grocy stopped'
}

@test "$clinom services grocy down" {
  run "${clicmd}" services grocy down
  assert_success && assert_output -p 'grocy stopped and removed'
}

@test "$clinom services grocy icon" {
  run "${clicmd}" services grocy icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services grocy cleanup" {
  run "${clicmd}" services grocy cleanup
  assert_success && assert_output -p 'cleaned up'
}

