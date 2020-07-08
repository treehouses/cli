#!/usr/bin/env bats
load ../test-helper

@test "$clinom magazines hackspace" {
  run "${clicmd}" magazines hackspace
  assert_output -p "HackSpace magazine is packed with projects for fixers and tinkerers of all abilities. We'll teach you new techniques and give you refreshers on familiar ones, from 3D printing, laser cutting, and woodworking to electronics and Internet of Things."
}

@test "$clinom magazines hackspace latest" {
  run "${clicmd}" magazines hackspace latest
  assert_success
}

@test "$clinom magazines hackspace all" {
  run "${clicmd}" magazines hackspace all
  assert_success
}
