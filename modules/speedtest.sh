#!/bin/bash

function speedtest {
  check_missing_packages "speedtest-cli"
  /usr/bin/speedtest "$@"
}
function speedtest_help {

  echo ""
  echo "Usage: $(basename "$0") speedtest"
  echo ""
  echo "tests internet download and upload speed"
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") speedtest"
  echo "      Outputs the speed of internet download and upload speed"
  echo ""
}
