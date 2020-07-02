#!/usr/bin/env bats
load ../test-helper

@test "$clinom magazine wireframe" {
  run "${clicmd}" magazine wireframe
  assert_output -p "Wireframe is a new fortnightly magazine that lifts the lid on video games. In every issue, we'll be looking at how games are made, who makes them, and even guide you through the process of making your own."
}

@test "$clinom magazine wireframe language" {
  run "${clicmd}" magazine wireframe language
  assert_success
}

@test "$clinom magazine wireframe latest" {
  run "${clicmd}" magazine wireframe latest
  assert_success
}

@test "$clinom magazine wireframe all" {
  run "${clicmd}" magazine wireframe all
  assert_success
}
