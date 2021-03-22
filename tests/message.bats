#!/usr/bin/env bats
load test-helper

@test "$clinom message gitter" {
  run "${clicmd}" message gitter
  assert_line 'Error: This command does not exist'
}

@test "$clinom message gitter apitoken" {
  run "${clicmd}" config add gitter_apitoken 123 
  run "${clicmd}" message gitter apitoken
  assert_success 
}

@test "$clinom message gitter authorize" {
  run "${clicmd}" message gitter authorize 1234567890 abcdefg
  assert_line --partial 'Your API access token is'
}

@test "$clinom message gitter apitoken without access token" {
  run "${clicmd}" config delete gitter_apitoken 
  run "${clicmd}" message gitter apitoken
  assert_line 'You do not have an authorized access token' 
}

@test "$clinom message gitter authorize without code" {
  run "${clicmd}" message gitter authorize
  assert_line --partial 'is missing'
}
