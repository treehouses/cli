#!/usr/bin/env bats
load test-helper

@test "$clinom magazine magpi" {
  run "${clicmd}" magazine magpi
  assert_output -p "The MagPi is The Official Raspberry Pi magazine. Written by and for the community, it is packed with Raspberry Pi-themed projects, computing and electronics tutorials, how-to guides, and the latest news and reviews."
}

@test "$clinom magazine magpi latest" {
  run "${clicmd}" magazine magpi latest
  assert_success
}

@test "$clinom magazine magpi all" {
  run "${clicmd}" magazine magpi all
  assert_success
}

@test "$clinom magazine hackspace" {
  run "${clicmd}" magazine hackspace
  assert_output -p "HackSpace magazine is packed with projects for fixers and tinkerers of all abilities. We'll teach you new techniques and give you refreshers on familiar ones, from 3D printing, laser cutting, and woodworking to electronics and Internet of Things."
}

@test "$clinom magazine hackspace latest" {
  run "${clicmd}" magazine hackspace latest
  assert_success
}

@test "$clinom magazine hackspace all" {
  run "${clicmd}" magazine hackspace all
  assert_success
}

@test "$clinom magazine wireframe" {
  run "${clicmd}" magazine wireframe
  assert_output -p "Wireframe is a new fortnightly magazine that lifts the lid on video games. In every issue, we'll be looking at how games are made, who makes them, and even guide you through the process of making your own."
}

@test "$clinom magazine wireframe latest" {
  run "${clicmd}" magazine wireframe latest
  assert_success
}

@test "$clinom magazine wireframe all" {
  run "${clicmd}" magazine wireframe all
  assert_success
}

@test "$clinom magazine helloworld" {
  run "${clicmd}" magazine helloworld
  assert_output -p "HelloWorld is the computing and digital making magazine for educators."
}

@test "$clinom magazine helloworld latest" {
  run "${clicmd}" magazine helloworld latest
  assert_success
}

@test "$clinom magazine helloworld all" {
  run "${clicmd}" magazine helloworld all
  assert_success
}
