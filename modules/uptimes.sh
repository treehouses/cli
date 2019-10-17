#!/bin/bash

function uptimes(){
  last_up_time=$(cat "$SCRIPTFOLDER"/templates/up_time)
  curr_up_time=$(uptime -s)
  if [[ "$last_up_time" != "$curr_up_time" ]]
  then
    uptime -s > "$SCRIPTFOLDER"/templates/up_time
    echo "Down Time was between $last_up_time and $curr_up_time"
    echo "System has been up since $curr_up_time"
  else
    up=$(uptime -s)
    echo "System has been up since $up"
  fi
}

function uptimes_help(){
  echo ""
  echo "Usage: $(basename "$0") uptimes"
  echo ""
  echo "Example:"
  echo " $(basename "$0") uptimes"
  echo "    displays the system uptime and time range between which it was down"
  echo ""
}
