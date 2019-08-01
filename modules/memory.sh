#!/bin/bash

function memory {
  if [ "$1" == "total" ] ; then
    memory_total
    echo "Your rpi has $((t)) B of total memory";
    exit 0
  fi

  if [ "$1" == "used" ] ; then
    memory_used
    echo "Your rpi has $((ubc)) B of used memory";
    exit 0
  fi

  if [ "$1" == "free" ] ; then
    memory_free
    echo "Your rpi has $((f)) B of free memory";
    exit 0
  fi

  memory_total
  memory_used
  memory_free
  
  echo "Your rpi has $((t)) B of total memory with $((ubc)) B used and $((f)) B avalaible"
}

function memory_total {
  free | grep Mem | cut -c 13-19
  t=$(free | grep Mem | cut -c 13-19)
}

function memory_used {
  free | grep Mem | cut -c 20-31
  free | grep Mem | cut -c 56-72
  u=$(free | grep Mem | cut -c 20-31)
  bc=$(free | grep Mem | cut -c 56-72)
  echo "$((u + bc))"
  ubc=$(echo)
}

function memory_free {
  free | grep Mem | cut -c 32-43
  f=$(free | grep Mem | cut -c 32-43)
}

