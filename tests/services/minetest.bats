#!/usr/bin/env bats
load ../test-helper

@test "$clinom services minetest info" {
  run "${clicmd}" services minetest info
  assert_success && assert_output -p 'https://www.minetest.net/'
}

@test "$clinom services minetest install" {
  run "${clicmd}" services minetest install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services minetest up" {
  run "${clicmd}" services minetest up
  sleep 5
  assert_success && assert_output -p 'minetest built and started'
}

@test "$clinom services minetest restart" {
  run "${clicmd}" services minetest restart
  sleep 5
  assert_success && assert_output -p 'minetest built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'minetest'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'minetest'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/minetest'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'minetest'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/minetest'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services minetest port" {
  run "${clicmd}" services minetest port
  assert_success && assert_output -p '30000'
}

@test "$clinom services minetest ps" {
  run "${clicmd}" services minetest ps
  assert_success && assert_output -p 'linuxserver/minetest'
}

@test "$clinom services minetest url" {
  run "${clicmd}" services minetest url
  assert_output -p '30000'
}

@test "$clinom services minetest autorun" {
  run "${clicmd}" services minetest autorun
  assert_success
}

@test "$clinom services minetest autorun true" {
  run "${clicmd}" services minetest autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services minetest stop" {
  run "${clicmd}" services minetest stop
  assert_success && assert_output -p 'minetest stopped'
}

@test "$clinom services minetest start" {
  run "${clicmd}" services minetest start
  assert_success && assert_output -p 'minetest started'
}

@test "$clinom services minetest down" {
  run "${clicmd}" services minetest down
  assert_success && assert_output -p 'minetest stopped and removed'
}

@test "$clinom services minetest icon" {
  run "${clicmd}" services minetest icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services minetest cleanup" {
  run "${clicmd}" services minetest cleanup
  assert_success && assert_output -p 'cleaned up'
}
