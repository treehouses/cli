#!/usr/bin/env bats
load test-helper

@test "$clinom shadowsocks" {
  run "${clicmd}" shadowsocks list
  assert_success && assert_output -p 'Config'
}

@test "$clinom shadowsocks start config" {
  run "${clicmd}" shadowsocks start config
  assert_success && assert_output -p 'config started'
}

@test "$clinom shadowsocks remove" {
  run "${clicmd}" shadowsocks remove config
  assert_success && assert_output -p 'removed'
}
