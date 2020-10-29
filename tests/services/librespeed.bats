#!/usr/bin/env bats
load ../test-helper

@test "$clinom services librespeed info" {
  run "${clicmd}" services librespeed info
  assert_success && assert_output -p 'https://github.com/librespeed/speedtest'
}

@test "$clinom services librespeed install" {
  run "${clicmd}" services librespeed install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services librespeed up" {
  run "${clicmd}" services librespeed up
  sleep 5
  assert_success && assert_output -p 'librespeed built and started'
}

@test "$clinom services librespeed start" {
  run "${clicmd}" services librespeed start
  sleep 5
  assert_success && assert_output -p 'librespeed started'
}

@test "$clinom services librespeed restart" {
  run "${clicmd}" services librespeed restart
  sleep 5
  assert_success && assert_output -p 'librespeed built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'librespeed'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'librespeed'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/librespeed'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'librespeed'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/librespeed'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services librespeed port" {
  run "${clicmd}" services librespeed port
  assert_success && assert_output -p '80'
}

@test "$clinom services librespeed ps" {
  run "${clicmd}" services librespeed ps
  assert_success && assert_output -p 'linuxserver/librespeed'
}

@test "$clinom services librespeed url" {
  run "${clicmd}" services librespeed url
  assert_output -p '80'
}

@test "$clinom services librespeed autorun" {
  run "${clicmd}" services librespeed autorun
  assert_success
}

@test "$clinom services librespeed autorun true" {
  run "${clicmd}" services librespeed autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services librespeed stop" {
  run "${clicmd}" services librespeed stop
  assert_success && assert_output -p 'librespeed stopped'
}

@test "$clinom services librespeed down" {
  run "${clicmd}" services librespeed down
  assert_success && assert_output -p 'librespeed stopped and removed'
}

@test "$clinom services librespeed icon" {
  run "${clicmd}" services librespeed icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services librespeed cleanup" {
  run "${clicmd}" services librespeed cleanup
  assert_success && assert_output -p 'cleaned up'
}

