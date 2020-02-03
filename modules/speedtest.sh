#!/bin/bash

function speedtest {
  check_missing_packages "speedtest-cli"
  /usr/bin/speedtest "$@"
}
function speedtest_help {
  echo
  echo "Usage: $BASENAME speedtest"
  echo
  echo "tests internet download and upload speed"
  echo
  echo "Examples:"
  echo "  $BASENAME speedtest"
  echo "      Outputs the speed of internet download and upload speed"
  echo
  echo "  $BASENAME speedtest -h"
  echo "      Outputs additional speedtest options built into speedtest"
  echo
}
