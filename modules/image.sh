#!/bin/bash

function image {
    cat /boot/version.txt
}

function image_help {
  echo
  echo "Usage: $(basename "$0") image"
  echo
  echo "Returns the version of the system image which is currently running"
  echo
  echo "Example:"
  echo "  $(basename "$0") image"
  echo "      Prints the current version of the system image."
  echo
}