#!/bin/bash

function version {
  node -p "require('$SCRIPTFOLDER/package.json').version"
}

function version_help () {
  echo ""
  echo "Usage: $(basename "$0") version"
  echo ""
  echo "Returns the version of $(basename "$0") command"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") version"
  echo "      Prints the version of $(basename "$0") currently installed."
  echo ""
}