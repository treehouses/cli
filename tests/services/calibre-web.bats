#!/usr/bin/env bats
load ../test-helper

@test "$clinom services calibre-web info" {
  run "${clicmd}" services calibre-web info
  assert_success && assert_output -p 'https://github.com/librespeed/speedtest'
}

@test "$clinom services calibre-web install" {
  run "${clicmd}" services calibre-web install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services calibre-web up" {
  run "${clicmd}" services calibre-web up
  sleep 5
  assert_success && assert_output -p 'calibre-web built and started'
}

@test "$clinom services calibre-web start" {
  run "${clicmd}" services calibre-web start
  sleep 5
  assert_success && assert_output -p 'calibre-web started'
}

@test "$clinom services calibre-web restart" {
  run "${clicmd}" services calibre-web restart
  sleep 5
  assert_success && assert_output -p 'calibre-web built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'calibre-web'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'calibre-web'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/calibre-web'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'calibre-web'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/calibre-web'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services calibre-web port" {
  run "${clicmd}" services calibre-web port
  assert_success && assert_output -p '8090'
}

@test "$clinom services calibre-web ps" {
  run "${clicmd}" services calibre-web ps
  assert_success && assert_output -p 'linuxserver/calibre-web'
}

@test "$clinom services calibre-web url" {
  run "${clicmd}" services calibre-web url
  assert_output -p '80'
}

@test "$clinom services calibre-web autorun" {
  run "${clicmd}" services calibre-web autorun
  assert_success
}

@test "$clinom services calibre-web autorun true" {
  run "${clicmd}" services calibre-web autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services calibre-web stop" {
  run "${clicmd}" services calibre-web stop
  assert_success && assert_output -p 'calibre-web stopped'
}

@test "$clinom services calibre-web down" {
  run "${clicmd}" services calibre-web down
  assert_success && assert_output -p 'calibre-web stopped and removed'
}

@test "$clinom services calibre-web icon" {
  run "${clicmd}" services calibre-web icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services calibre-web cleanup" {
  run "${clicmd}" services calibre-web cleanup
  assert_success && assert_output -p 'cleaned up'
}