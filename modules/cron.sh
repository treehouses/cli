#!/bin/bash
  #temp file will store crontab scripts, which when selected will be written to the temp file.
  #The contents of the temp file will be pushed to cron

function cron {
  options="$1" #preset options
  cronlist=/tmp/cronlist.txt #temp file
  case "$options" in
    "") #lists current cron tasks
        echo "List of cron jobs:"
      if [ #cron task list is empty# ]; then
        echo "The system has no cron tasks" ; echo
      fi
    "0W") #adds a daily reboot to system - RPi 0's will benefit from this
      #append command to temp file
      #push unique command into crontab
      echo "Daily reboot added to system"
      ;;
    "tor") #executes 'tor notice now' every 3 days
      #append command to temp file

      echo "\"tor notice now\" will now execute every 3 days" ; echo
      ;;
    "timestamp") #timestamp every 15 minutes logged
      #append command to temp file

      echo "\"uptimelog.txt\" created in /tmp/ and will timestamp every 15 minutes" ; echo
      ;;
    *) #prompts help for bad inputs
      cron_help
      exit 1
      ;;
  esac
}

function cron_help {
  echo
  echo "Usage: $(basename "$0") cron [options]        Lists all tasks assigned to cron"
  echo
  echo "Options:"
  echo   "0W           Creates a daily reboot task; Needed for RPi Zero W"
  echo   "tor          Sends \"tor notice now\" every other three days"
  echo   "timestamp    Creates timestamp log, logging every 15 minutes"
  echo
  echo
  echo "Examples:"
  echo "$(basename "$0") cron"
  echo "  List of cron jobs:"
  echo "    * * 3 * * tor notice now"
  echo "    15 * * * * echo \"date -T > /tmp/uptimelog.txt\""
  echo
  echo "$(basename "$0") cron 0W"
  echo "  \"Daily Reboot\" tast established"
  echo
  echo "$(basename "$0") cron tor"
  echo "  \"tor notice now\" will now automatically execute every 3 days"
  echo
  echo "$(basename "$0") cron timestamp"
  echo "  \"date --date=T\" will be logged every 15 minutes to cronlog.txt"
  echo
}
