#!/bin/bash
function margaritas {
  checkargn $# 1
  num=$1
  if [ "$num" = "" ]; then
    num=1
  fi
  if [ $num -lt 0 ]; then
    echo "Please enter a valid number of margaritas to print."
    exit 1
  fi
  echo "Here are $num margaritas just for you... :)"
  echo
  for i in $(seq "$num")
  do 
    echo "             \\\\" 
    sleep 0.1
    echo "              \\\\"
    sleep 0.1
    echo "             __\\\\_______"
    sleep 0.1
    echo "             \\ooooooooo/"
    sleep 0.1
    echo "              \\\\ooooo//"
    sleep 0.1
    echo "               \\\\ooo//"
    sleep 0.1
    echo "                \\\\o//"
    sleep 0.1
    echo "                 |||"
    sleep 0.1
    echo "                 |||"
    sleep 0.1
    echo "                 |||"
    sleep 0.1
    echo "                // \\\\"
    sleep 0.1
    echo "               ^^^^^^^"
    sleep 0.5
  done
}

function margaritas_help {
  echo
  echo "Usage: $BASENAME margaritas [n]"
  echo
  echo "Prints out n-margaritas at a safe pace"
  echo
  echo "Example:"
  echo "  $BASENAME margaritas"
  echo "    Here are 1 margaritas for you... :)"
  echo 
  echo "             \\\\" 
  echo "              \\\\"
  echo "             __\\\\_______"
  echo "             \\ooooooooo/"
  echo "              \\\\ooooo//"
  echo "               \\\\ooo//"
  echo "                \\\\o//"
  echo "                 |||"
  echo "                 |||"
  echo "                 |||"
  echo "                // \\\\"
  echo "               ^^^^^^^"
  echo
  echo "  $BASENAME margaritas 2"
  echo "    Here are 2 margaritas for you... :)"
  echo 
  echo "               \\\\" 
  echo "                \\\\"
  echo "               __\\\\_______"
  echo "               \\ooooooooo/"
  echo "                \\\\ooooo//"
  echo "                 \\\\ooo//"
  echo "                  \\\\o//"
  echo "                   |||"
  echo "                   |||"
  echo "                   |||"
  echo "                  // \\\\"
  echo "                 ^^^^^^^"
  echo "               \\\\" 
  echo "                \\\\"
  echo "               __\\\\_______"
  echo "               \\ooooooooo/"
  echo "                \\\\ooooo//"
  echo "                 \\\\ooo//"
  echo "                  \\\\o//"
  echo "                   |||"
  echo "                   |||"
  echo "                   |||"
  echo "                  // \\\\"
  echo "                 ^^^^^^^"
  echo
  }
