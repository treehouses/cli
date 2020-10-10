#!/usr/bin/env bats
load ../test-helper

@test "$clinom services dokuwiki info" {
  run "${clicmd}" services dokuwiki info
  assert_success && assert_output -p 'https://github.com/linuxserver/docker-dokuwiki'
}

@test "$clinom services dokuwiki install" {
  run "${clicmd}" services dokuwiki install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services dokuwiki up" {
  run "${clicmd}" services dokuwiki up
  sleep 5
  assert_success && assert_output -p 'dokuwiki built and started'
}

@test "$clinom services dokuwiki start" {
  run "${clicmd}" services dokuwiki start
  sleep 5
  assert_success && assert_output -p 'dokuwiki started'
}

@test "$clinom services dokuwiki restart" {
  run "${clicmd}" services dokuwiki restart
  sleep 5
  assert_success && assert_output -p 'dokuwiki built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'dokuwiki'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'dokuwiki'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/dokuwiki'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'dokuwiki'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/dokuwiki'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 8093'
}

@test "$clinom services dokuwiki port" {
  run "${clicmd}" services dokuwiki port
  assert_success && assert_output -p '8093'
}

@test "$clinom services dokuwiki ps" {
  run "${clicmd}" services dokuwiki ps
  assert_success && assert_output -p 'linuxserver/dokuwiki'
}

@test "$clinom services dokuwiki url" {
  run "${clicmd}" services dokuwiki url
  assert_output -p '8093'
}

@test "$clinom services dokuwiki autorun" {
  run "${clicmd}" services dokuwiki autorun
  assert_success
}

@test "$clinom services dokuwiki autorun true" {
  run "${clicmd}" services dokuwiki autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services dokuwiki stop" {
  run "${clicmd}" services dokuwiki stop
  assert_success && assert_output -p 'dokuwiki stopped'
}

@test "$clinom services dokuwiki down" {
  run "${clicmd}" services dokuwiki down
  assert_success && assert_output -p 'dokuwiki stopped and removed'
}

@test "$clinom services dokuwiki icon" {
  run "${clicmd}" services dokuwiki icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services dokuwiki cleanup" {
  run "${clicmd}" services dokuwiki cleanup
  assert_success && assert_output -p 'cleaned up'
}
