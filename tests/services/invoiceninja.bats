#!/usr/bin/env bats
load ../test-helper

@test "$clinom services invoiceninja info" {
  run "${clicmd}" services invoiceninja info
  assert_success && assert_output -p 'https://github.com/ole-vi/invoiceninja'
}

@test "$clinom services invoiceninja install" {
  run "${clicmd}" services invoiceninja install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services invoiceninja up" {
  run "${clicmd}" services invoiceninja up
  sleep 5
  assert_success && assert_output -p 'invoiceninja built and started'
}

@test "$clinom services invoiceninja restart" {
  run "${clicmd}" services invoiceninja restart
  sleep 5
  assert_success && assert_output -p 'invoiceninja built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'invoiceninja'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'invoiceninja'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/rpi-invoiceninja'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'invoiceninja'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/rpi-invoiceninja'
}

@test "$clinom services invoiceninja port" {
  run "${clicmd}" services invoiceninja port
  assert_success && assert_output -p '8090'
}

@test "$clinom services invoiceninja ps" {
  run "${clicmd}" services invoiceninja ps
  assert_success && assert_output -p 'treehouses/rpi-invoiceninja'
}

@test "$clinom services invoiceninja url" {
  run "${clicmd}" services invoiceninja url
  assert_output -p '8090'
}

@test "$clinom services invoiceninja autorun" {
  run "${clicmd}" services invoiceninja autorun
  assert_success
}

@test "$clinom services invoiceninja autorun true" {
  run "${clicmd}" services invoiceninja autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services invoiceninja stop" {
  run "${clicmd}" services invoiceninja stop
  assert_success && assert_output -p 'invoiceninja stopped'
}

@test "$clinom services invoiceninja start" {
  run "${clicmd}" services invoiceninja start
  assert_success
}

@test "$clinom services invoiceninja down" {
  run "${clicmd}" services invoiceninja down
  assert_success && assert_output -p 'invoiceninja stopped and removed'
}

@test "$clinom services invoiceninja icon" {
  run "${clicmd}" services invoiceninja icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services invoiceninja cleanup" {
  run "${clicmd}" services invoiceninja cleanup
  assert_success && assert_output -p 'cleaned up'
}
