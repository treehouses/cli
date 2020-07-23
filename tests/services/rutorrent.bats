#!/usr/bin/env bats
load ../test-helper

@test "$clinom services rutorrent info" {
  run "${clicmd}" services rutorrent info
  assert_success && assert_output -p 'https://github.com/linuxserver/docker-rutorrent.git'
}

@test "$clinom services rutorrent install" {
  run "${clicmd}" services rutorrent install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services rutorrent up" {
  run "${clicmd}" services rutorrent up
  sleep 5
  assert_success && assert_output -p 'rutorrent built and started'
}

@test "$clinom services rutorrent start" {
  run "${clicmd}" services rutorrent start
  sleep 5
  assert_success && assert_output -p 'rutorrent started'
}

@test "$clinom services rutorrent restart" {
  run "${clicmd}" services rutorrent restart
  sleep 5
  assert_success && assert_output -p 'rutorrent built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'rutorrent'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'rutorrent'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/rutorrent'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'rutorrent'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/rutorrent'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 8097'
}

@test "$clinom services rutorrent port" {
  run "${clicmd}" services rutorrent port
  assert_success && assert_output -p '8097'
}

@test "$clinom services rutorrent ps" {
  run "${clicmd}" services rutorrent ps
  assert_success && assert_output -p 'linuxserver/rutorrent'
}

@test "$clinom services rutorrent url" {
  run "${clicmd}" services rutorrent url
  assert_output -p '8097'
}

@test "$clinom services rutorrent autorun" {
  run "${clicmd}" services rutorrent autorun
  assert_success
}

@test "$clinom services rutorrent autorun true" {
  run "${clicmd}" services rutorrent autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services rutorrent stop" {
  run "${clicmd}" services rutorrent stop
  assert_success && assert_output -p 'rutorrent stopped'
}

@test "$clinom services rutorrent down" {
  run "${clicmd}" services rutorrent down
  assert_success && assert_output -p 'rutorrent stopped and removed'
}

@test "$clinom services rutorrent icon" {
  run "${clicmd}" services rutorrent icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services rutorrent cleanup" {
  run "${clicmd}" services rutorrent cleanup
  assert_success && assert_output -p 'cleaned up'
}
