#!/usr/bin/env bats
load ../test-helper

@test "$clinom services jellyfin info" {
  run "${clicmd}" services jellyfin info
  assert_success && assert_output -p 'https://github.com/linuxserver/docker-jellyfin'
}

@test "$clinom services jellyfin install" {
  run "${clicmd}" services jellyfin install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services jellyfin up" {
  run "${clicmd}" services jellyfin up
  sleep 5
  assert_success && assert_output -p 'jellyfin built and started'
}

@test "$clinom services jellyfin start" {
  run "${clicmd}" services jellyfin start
  sleep 5
  assert_success && assert_output -p 'jellyfin started'
}

@test "$clinom services jellyfin restart" {
  run "${clicmd}" services jellyfin restart
  sleep 5
  assert_success && assert_output -p 'jellyfin built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'jellyfin'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'jellyfin'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/jellyfin'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'jellyfin'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/jellyfin'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 8096'
}

@test "$clinom services jellyfin port" {
  run "${clicmd}" services jellyfin port
  assert_success && assert_output -p '8096'
}

@test "$clinom services jellyfin ps" {
  run "${clicmd}" services jellyfin ps
  assert_success && assert_output -p 'linuxserver/jellyfin'
}

@test "$clinom services jellyfin url" {
  run "${clicmd}" services jellyfin url
  assert_output -p '8096'
}

@test "$clinom services jellyfin autorun" {
  run "${clicmd}" services jellyfin autorun
  assert_success
}

@test "$clinom services jellyfin autorun true" {
  run "${clicmd}" services jellyfin autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services jellyfin stop" {
  run "${clicmd}" services jellyfin stop
  assert_success && assert_output -p 'jellyfin stopped'
}

@test "$clinom services jellyfin down" {
  run "${clicmd}" services jellyfin down
  assert_success && assert_output -p 'jellyfin stopped and removed'
}

@test "$clinom services jellyfin icon" {
  run "${clicmd}" services jellyfin icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services jellyfin cleanup" {
  run "${clicmd}" services jellyfin cleanup
  assert_success && assert_output -p 'cleaned up'
}
