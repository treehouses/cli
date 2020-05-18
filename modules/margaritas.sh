#!/bin/bash
function margaritas {
  checkargn $# 2
  num=$1
  hflag=0
  re='^[0-9]+$'
  if [ "$2" = "half-full" ]; then
    hflag=1
  fi
  if [ "$num" = "" ]; then
    num=1
  fi
  if ! [[ $num =~ $re ]] ; then
    echo "Please enter a valid number"
    exit 1
  fi
  if [ $num -lt 0 ]; then
    echo "Please enter a valid number of margaritas to print."
    exit 1
  fi
  if [ $num -gt 1 ] || [ "$num" = "0" ]; then
    echo "Here are $num margaritas just for you... :)"
  else
    echo "Here is 1 margarita for you... :)"
  fi
  if [ "$hflag" = "1" ]; then
    echo "...half full"
  fi
  echo
  if [ "$hflag" = "0" ]; then
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
  else
    for i in $(seq "$num")
    do 
      echo "             \\\\" 
      sleep 0.1
      echo "              \\\\"
      sleep 0.1
      echo "             __\\\\_______"
      sleep 0.1
      echo "             \\         /"
      sleep 0.1
      echo "              \\\\     //"
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

  fi
}

function margaritas_help {
  echo
  echo "Usage: $BASENAME margaritas [n]"
  echo
  echo "Prints out n-margaritas at a safe pace"
  echo
  echo "Example:"
  echo "  $BASENAME margaritas"
  echo "    Here is 1 margarita for you... :)"
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
  echo "  $BASENAME margaritas 2 half-full"
  echo "    Here are 2 margaritas just for you... :)"
  echo "    ...half full"
  echo
  echo "               \\\\" 
  echo "                \\\\"
  echo "               __\\\\_______"
  echo "               \\         /"
  echo "                \\\\     //"
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
  echo "               \\         /"
  echo "                \\\\     //"
  echo "                 \\\\ooo//"
  echo "                  \\\\o//"
  echo "                   |||"
  echo "                   |||"
  echo "                   |||"
  echo "                  // \\\\"
  echo "                 ^^^^^^^"
  echo
}
