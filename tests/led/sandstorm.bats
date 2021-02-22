#!usr/bin/env bats
load ../test-helper

@test "$clinom led sandstorm" {
  run "{clicmd}" led sandstorm
  assert_success && assert_output -p
`heartbeat`
}
