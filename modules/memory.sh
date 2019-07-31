#!/bin/bash

function memory {
  if [ "$1" == "total" ] ; then
    memory_total
    echo 'Your rpi has (($total)) B of total memory';
    exit 0
  fi

  if [ "$1" == "used" ] ; then
    memory_used
    echo 'Your rpi has (($used + $buff/cache)) B of used memory';
    exit 0
  fi

  if [ "$1" == "free" ] ; then
    memory_free
    echo 'Your rpi has (($free)) B of free memory';
    exit 0
  fi

  free
  echo 'Your rpi has (($total)) B of total memory with (($used + $buff/cache)) B used and $free B avalaible'
}

function memory_total {
  free
}

function memory_used {
  free
}

function memory_free {
  free
}

