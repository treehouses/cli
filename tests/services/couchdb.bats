#!/usr/bin/env bats
load ../test-helper

@test "$clinom services couchdb info" {
  run "${clicmd}" services couchdb info
  assert_success && assert_output -p 'Couch Replication Protocol'
}

@test "$clinom services couchdb install" {
  run "${clicmd}" services couchdb install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services couchdb up" {
  run "${clicmd}" services couchdb up
  sleep 5
  assert_success && assert_output -p 'couchdb built and started'
}

@test "$clinom services couchdb restart" {
  run "${clicmd}" services couchdb restart
  sleep 5
  assert_success && assert_output -p 'couchdb built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'couchdb'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'couchdb'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/couchdb'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'couchdb'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/couchdb'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services couchdb port" {
  run "${clicmd}" services couchdb port
  assert_success && assert_output -p '5984'
}

@test "$clinom services couchdb ps" {
  run "${clicmd}" services couchdb ps
  assert_success && assert_output -p 'treehouses/couchdb'
}

@test "$clinom services couchdb url" {
  run "${clicmd}" services couchdb url
  assert_output -p '5984'
}

@test "$clinom services couchdb autorun" {
  run "${clicmd}" services couchdb autorun
  assert_success
}

@test "$clinom services couchdb autorun true" {
  run "${clicmd}" services couchdb autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services couchdb stop" {
  run "${clicmd}" services couchdb stop
  assert_success && assert_output -p 'couchdb stopped'
}

@test "$clinom services couchdb start" {
  run "${clicmd}" services couchdb start
  assert_success && assert_output -p 'couchdb started'
}

@test "$clinom services couchdb down" {
  run "${clicmd}" services couchdb down
  assert_success && assert_output -p 'couchdb stopped and removed'
}

@test "$clinom services couchdb icon" {
  run "${clicmd}" services couchdb icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services couchdb cleanup" {
  run "${clicmd}" services couchdb cleanup
  assert_success && assert_output -p 'cleaned up'
}
