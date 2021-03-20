#!/usr/bin/env bats
load test-helper

@test "$clinom message slack apitoken" {
  run "${clicmd}" message slack apitoken
  assert_success
}

@test "$clinom message slack apitoken (create token)" {
  run "${clicmd}" config delete xoxp-fake-token
  run "${clicmd}" message slack apitoken xoxp-fake-token
  assert_output --partial 'Your slack apitoken'
  run "${clicmd}" config delete xoxp-fake-token
}

@test "$clinom message slack apitoken (create invalid token)" {
  run "${clicmd}" config delete fake-token
  run "${clicmd}" message slack apitoken fake-token
  assert_output --partial 'invalid token'
  run "${clicmd}" config delete fake-token
}

# Needs to 'store' previous tokens and re-add them
@test "$clinom message slack apitoken (no token)" {
  run "${clicmd}" config clear
  run "${clicmd}" message slack apitoken
  assert_output --partial 'api.slack.com/apps'
}

@test "$clinom message slack apitoken (with token)" {
  run "${clicmd}" message slack apitoken xoxp-fake-token
  run "${clicmd}" message slack apitoken
  assert_output --partial 'Your API access token is'
  "${clicmd}" config delete xoxp-fake-token
}

@test "$clinom message slack apitoken (after invalid token)" {
  run "${clicmd}" config clear
  run "${clicmd}" message slack apitoken fake-token
  run "${clicmd}" message slack apitoken
  assert_output --partial 'api.slack.com/apps'
  "${clicmd}" config delete fake-token
}
