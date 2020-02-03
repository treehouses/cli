#!/bin/bash

function version {
  node -p "require('$SCRIPTFOLDER/package.json').version"
}

function version_help () {
  echo
  echo "Usage: $BASENAME version"
  echo
  echo "Returns the version of $BASENAME command"
  echo
  echo "Example:"
  echo "  $BASENAME version"
  echo "      Prints the version of $BASENAME currently installed."
  echo
}