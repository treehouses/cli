#!/bin/bash
 SCRIPTPATH=$(realpath "$0")
 SCRIPTFOLDER=$(dirname "$SCRIPTPATH")

function uptimes(){
if [[ ! -f "$SCRIPTFOLDER/templates/up_time" ]]
then
uptime -s > "$SCRIPTFOLDER"/templates/up_time 
up=$(uptime -s)
echo "System is up since $up"
else
last_up_time=$(cat "$SCRIPTFOLDER"/templates/up_time)
curr_up_time=$(uptime -s)
if [[ "$last_up_time" != "$curr_up_time" ]]
then
uptime -s > "$SCRIPTFOLDER"/templates/up_time
echo "Down Time was between $last_up_time and $curr_up_time"
echo "System has been up since $curr_up_time"
else
up=$(uptime -s)
echo "System is up since $up"
fi
fi 
}
