#!/usr/bin/env bats
load test-helper

@test "$clinom picture" {
  run "${clicmd}" picture
  assert_success && assert_output -p 'Usage: treehouses picture' && assert_output -p 'Views a picture in the terminal.'
}

@test "$clinom picture foo.png (invalid image)" {
  run "${clicmd}" picture HasAnyoneReallyBeenFarEvenasDecidedtoUseEvenGoWanttodoLookMoreLike.png
  assert_success && assert_output -p "Can't open file (permission?):"
}


