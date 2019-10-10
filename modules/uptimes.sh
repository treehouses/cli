#!/bin/bash
if [[ ! -f "../templates/up_time" ]]
then
uptime -s > ../templates/up_time
else
last_up_time=$(cat ../templates/up_time)
curr_up_time=$(uptime -s)
if [[ "$last_up_time" != "$curr_up_time" ]]
then
echo "Down Time was between $last_up_time and $curr_up_time"
uptime -s > ../templates/up_time
fi
fi 
