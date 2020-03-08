#!/usr/bin/env bats
load test-helper

@test "$clinom speedtest" {
  run "${clicmd}" speedtest
  assert_success && assert_output -p 'Upload'
}

@test "$clinom speedtest -h" {
  run "${clicmd}" speedtest -h
  assert_success && assert_output -p 'https://github.com/sivel/speedtest-cli'
}