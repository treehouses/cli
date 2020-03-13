#!/bin/bash
# These tests are designed to be used
# with a RPi that is using its ethernet port
# If the networkmode is Wifi
# a lot of the tests will be skipped
# for wireless testing
export nssidname='YOUR-WIFI-NAME'
export nwifipass='YOUR-WIFI-PASS'
bats ./
