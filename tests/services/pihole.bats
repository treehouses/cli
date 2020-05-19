#!/usr/bin/env bats
load ../test-helper

@test "$clinom services pihole info" {
  run "${clicmd}" services pihole info
  assert_success && assert_output -p 'https://github.com/pi-hole/docker-pi-hole'
}

@test "$clinom services pihole install" {
  run "${clicmd}" services pihole install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services pihole up" {
  run "${clicmd}" services pihole up
  sleep 5
  assert_success && assert_output -p 'pihole built and started'
}

@test "$clinom services pihole restart" {
  run "${clicmd}" services pihole restart
  sleep 5
  assert_success && assert_output -p 'pihole built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'pihole'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'pihole'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'pihole/pihole'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'pihole'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'pihole/pihole'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services pihole port" {
  run "${clicmd}" services pihole port
  assert_success && assert_output -p '8053'
}

@test "$clinom services pihole ps" {
  run "${clicmd}" services pihole ps
  assert_success && assert_output -p 'pihole/pihole'
}

@test "$clinom services pihole url" {
  run "${clicmd}" services pihole url
  assert_output -p '8053'
}

@test "$clinom services pihole autorun" {
  run "${clicmd}" services pihole autorun
  assert_success
}

@test "$clinom services pihole autorun true" {
  run "${clicmd}" services pihole autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services pihole stop" {
  run "${clicmd}" services pihole stop
  assert_success && assert_output -p 'pihole stopped'
}

@test "$clinom services pihole start" {
  run "${clicmd}" services pihole start
  assert_success && assert_output -p 'pihole started'
}

@test "$clinom services pihole down" {
  run "${clicmd}" services pihole down
  assert_success && assert_output -p 'pihole stopped and removed'
}

@test "$clinom services pihole icon" {
  run "${clicmd}" services pihole icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services pihole cleanup" {
  run "${clicmd}" services pihole cleanup
  assert_success && assert_output -p 'cleaned up'
}
