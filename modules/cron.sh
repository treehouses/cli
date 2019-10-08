#!/bin/bash
  #temp file will store crontab scripts, which when selected will be written to the temp file.
  #The contents of the temp file will be pushed to cron

function cron {
  logfile=/var/log/uptime.log
  cronjoblist=$(crontab -l)
  grepreboot=$(grep reboot)
  greptor=$(grep tor)
  greptimelog=$(grep uptime.log)
  options="$1"
  if [ ! -f ${logfile} ]; then
    touch ${logfile}
  fi
  case "$options" in
    "") #lists current cron tasks
        echo "List of cron jobs:"
      if [ ${cronjoblist}==null ]; then
        echo "The system has no cron jobs" ; echo
      else
        ${cronjoblist} ; echo
      fi
      ;;

    "0W") #adds/removes a daily reboot to system - RPi 0's will benefit from this
      if [ ! ${grepreboot} ]; then
        $("(crontab -l ; echo \"@daily reboot now\") 2>&1 | grep -v \"no crontab\" | sort | uniq | crontab -")
        echo "\"Daily Reboot\" cron job established" ; echo
      elif [ ${grepreboot} ]; then
        $("(crontab -l ; echo \"@daily reboot now\") 2>&1 | grep -v \"no crontab\" | grep -v reboot |  sort | uniq | crontab -")
        echo "\"Daily Reboot\" cron job removed" ; echo
      fi
      ;;

    "tor") #add/removes execution of 'tor notice now' every 3 days
      if [ ! ${greptor} ]; then
        $("(crontab -l ; echo \"0 */72 * * * treehouses tor notice now\") 2>&1 | grep -v \"no crontab\" | sort | uniq | crontab -")
          echo "\"treehouses tor notice now\" will now execute every 72 hours"
      elif [ ${greptor} ]; then
        $("(crontab -l ; echo \"0 */72 * * * treehouses tor notice now\") 2>&1 | grep -v \"no crontab\" | grep -v tor | sort | uniq | crontab -")
          echo "\"treehouses tor notice now\" will no longer execute every 72 hours"
      fi
      ;;

    "timestamp") #adds/removes timestamp logging every 15 minutes
      if [ ! ${greptimelog} ]; then
        $("(crontab -l ; echo \"15 * * * * date >> /var/log/uptime.log\") 2>&1 | grep -v \"no crontab\" | sort | uniq | crontab -")
        echo "\"uptime.log\" created in /var/log/ and will timestamp every 15 minutes" ; echo
      elif [ ${greptimelog} ]; then
        $("(crontab -l ; echo \"15 * * * * date >> /var/log/uptime.log\") 2>&1 | grep -v \"no crontab\" | grep -v uptime.log |  sort | uniq | crontab -")
        echo "cron timestamping stopped and \"uptime.log\" removed from /var/log/" ; echo
      fi
      ;;

    *) #prompts help for bad inputs
      cron_help
      exit 1
      ;;
  esac
}

function cron_help {
  echo
  echo "Usage: $(basename "$0") cron [option]        Lists all cron jobs [Adds job to cron, or removes it if present]"
  echo "  Options:"
  echo "    0W           Creates a daily reboot task; Needed for RPi Zero W"
  echo "    tor          Sends \"tor notice now\" every 72 hours"
  echo "    timestamp    Creates timestamp log, logging every 15 minutes"
  echo
  echo
  echo "Examples:"
  echo "$(basename "$0") cron"
  echo "  List of cron jobs:"
  echo "    0 */72 * * * treehouses tor notice now"
  echo "    15 * * * * echo \"date > /tmp/uptimelog.txt\""
  echo "    @daily reboot now"
  echo
  echo "$(basename "$0") cron 0W"
  echo "  \"Daily Reboot\" cron job established"
  echo
  echo "$(basename "$0") cron tor"
  echo "  \"treehouses tor notice now\" will execute every 72 hours"
  echo
  echo "$(basename "$0") cron timestamp"
  echo "  \"date\" will be logged every 15 minutes to cronlog.txt"
  echo
}
