#!/usr/bin/env bats
load ../test-helper

@test "$clinom magazines wireframe" {
  run "${clicmd}" magazines wireframe
  assert_output -p "Wireframe is a new fortnightly magazine that lifts the lid on video games. In every issue, we'll be looking at how games are made, who makes them, and even guide you through the process of making your own."
}

@test "$clinom magazines wireframe latest" {
  run "${clicmd}" magazines wireframe latest
  assert_success
}

@test "$clinom magazines wireframe all" {
  run "${clicmd}" magazines wireframe all
  assert_success
}
