#!/bin/bash

function networkmode {
  if [ -f "/etc/network/mode" ]; then
    cat /etc/network/mode
  else
    echo "default"
  fi
}

function networkmode_help {
  echo ""
  echo "Usage: $(basename "$0") networkmode"
  echo ""
  echo "Outputs the current network mode"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") networkmode"
  echo "      Will output the current network mode that has been set up using $(basename "$0")"
  echo ""
}