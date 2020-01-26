#!/bin/bash

function image {
    cat /boot/version.txt
}

function image_help {
  echo
  echo "Usage: $BASENAME image"
  echo
  echo "Returns the version of the system image which is currently running"
  echo
  echo "Example:"
  echo "  $BASENAME image"
  echo "      Prints the current version of the system image."
  echo
}