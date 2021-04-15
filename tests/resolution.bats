#!/usr/bin/env bats
load test-helper

@test "$clinom resolution" {
  run "${clicmd}" resolution
  assert_success && assert_output -p 'hdmi group should be either'
}

@test "$clinom resolution cea" {
  run "${clicmd}" resolution cea
  assert_output -p 'mode is not available' && assert_output -p 'Group CEA has'
}

@test "$clinom resolution cea 4" {
  run "${clicmd}" resolution cea 4
  assert_output -p 'Screen resolution set to mode4:' && assert_output -p 'reboot needed to see the changes'
}

@test "$clinom resolution cea 1337 (non-existent mode)" {
  run "${clicmd}" resolution cea 1337
  assert_output -p 'mode is not available' && assert_output -p 'Group CEA has'
}

@test "$clinom resolution dmt" {
  run "${clicmd}" resolution dmt
  assert_output -p 'mode is not available' && assert_output -p 'Group DMT has'
}

@test "$clinom resolution dmt 4" {
  run "${clicmd}" resolution dmt 4
  assert_output -p 'Screen resolution set to mode4:' && assert_output -p 'reboot needed to see the changes'
}

@test "$clinom resolution dmt 1337 (non-existent mode)" {
  run "${clicmd}" resolution dmt 1337
  assert_output -p 'mode is not available' && assert_output -p 'Group DMT has'
}

