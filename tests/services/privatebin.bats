#!/usr/bin/env bats
load ../test-helper

@test "$clinom services privatebin info" {
  run "${clicmd}" services privatebin info
  assert_success && assert_output -p 'https://github.com/treehouses/privatebin'
}

@test "$clinom services privatebin install" {
  run "${clicmd}" services privatebin install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services privatebin up" {
  run "${clicmd}" services privatebin up
  sleep 5
  assert_success && assert_output -p 'privatebin built and started'
}

@test "$clinom services privatebin restart" {
  run "${clicmd}" services privatebin restart
  sleep 5
  assert_success && assert_output -p 'privatebin built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'privatebin'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'privatebin'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/privatebin'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'privatebin'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/privatebin'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services privatebin port" {
  run "${clicmd}" services privatebin port
  assert_success && assert_output -p '8083'
}

@test "$clinom services privatebin ps" {
  run "${clicmd}" services privatebin ps
  assert_success && assert_output -p 'treehouses/privatebin'
}

@test "$clinom services privatebin url" {
  run "${clicmd}" services privatebin url
  assert_output -p '8083'
}

@test "$clinom services privatebin autorun" {
  run "${clicmd}" services privatebin autorun
  assert_success
}

@test "$clinom services privatebin autorun true" {
  run "${clicmd}" services privatebin autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services privatebin stop" {
  run "${clicmd}" services privatebin stop
  assert_success && assert_output -p 'privatebin stopped'
}

@test "$clinom services privatebin start" {
  run "${clicmd}" services privatebin start
  assert_success && assert_output -p 'privatebin started'
}

@test "$clinom services privatebin down" {
  run "${clicmd}" services privatebin down
  assert_success && assert_output -p 'privatebin stopped and removed'
}

@test "$clinom services privatebin icon" {
  run "${clicmd}" services privatebin icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services privatebin cleanup" {
  run "${clicmd}" services privatebin cleanup
  assert_success && assert_output -p 'cleaned up'
}
