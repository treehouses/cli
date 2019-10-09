#!/bin/bash

function cron {
  options="$1"
  case "$options" in
    "") #lists current cron tasks
        echo "List of cron jobs:"
      if [ $(crontab -l | wc -c) -eq 0 ]; then
        echo "The system has no cron jobs"
      else
        $(echo crontab -l)
      fi
      ;;

    "0W") #adds/removes a daily reboot to system - RPi 0's will benefit from this
      if [[ $(crontab -l | grep "@daily") != "@daily reboot now" ]]; then
        $((crontab -l ; echo "@daily reboot now") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -)
        echo "\"Daily Reboot\" cron job established"
      elif [[ $(crontab -l | grep "@daily") == "@daily reboot now" ]]; then
        $((crontab -l ; echo "@daily reboot now") 2>&1 | grep -v "no crontab" | grep -v "@daily" | sort | uniq | crontab -)
        echo "\"Daily Reboot\" cron job removed"
      fi
      ;;

    "tor") #add/removes execution of 'tor notice now' every 3 days
      if [[ $(crontab -l | grep tor) != "0 */72 * * * treehouses tor notice now" ]]; then
        $((crontab -l ; echo "0 */72 * * * treehouses tor notice now") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -)
        echo "\"treehouses tor notice now\" cron job established"
      elif [[ $(crontab -l | grep tor) == "0 */72 * * * treehouses tor notice now" ]]; then
         $((crontab -l ; echo "0 */72 * * * treehouses tor notice now") 2>&1 | grep -v "no crontab" | grep -v "tor" | sort | uniq | crontab -)
        echo "\"treehouses tor notice now\" cron job removed"
      fi
      ;;

    "timestamp") #adds/removes timestamp logging every 15 minutes
      #Make log file if not found
      if [ ! -f /var/log/uptime.log ]; then
        $(sudo touch /var/log/uptime.log)
        echo "created \"uptime.log\" in /var/log/"
      fi

      if [[ $(crontab -l | grep date) != "15 * * * * date >> /var/log/uptime.log" ]]; then
        $((crontab -l ; echo "15 * * * * date >> /var/log/uptime.log") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -)
        echo "\"timestamp /var/log/uptime.log every 15 minutes\" cron job established"
      elif [[ $(crontab -l | grep date) == "15 * * * * date >> /var/log/uptime.log" ]]; then
        $((crontab -l ; echo "15 * * * * date >> /var/log/uptime.log") 2>&1 | grep -v "no crontab" | grep -v "date" | sort | uniq | crontab -)
        echo "timestamping cron job removed"
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
  echo "Usage: $(basename "$0") cron [0W|tor|timestamp]                   lists all active cron jobs [adds job to cron, or removes it if present]"
  echo "  Options:"
  echo "    0W           Creates a daily reboot task; Needed for RPi Zero W"
  echo "    tor          Sends \"tor notice now\" every 72 hours"
  echo "    timestamp    Creates /var/log/uptime.log, logging every 15 minutes"
  echo
  echo "Examples:"
  echo "  $(basename "$0") cron"
  echo "    List of cron jobs:"
  echo "    0 */72 * * * treehouses tor notice now"
  echo "    15 * * * * date >> /var/log/uptime.log"
  echo "    @daily reboot now"
  echo
  echo "  $(basename "$0") cron 0W"
  echo "    \"Daily Reboot\" cron job removed"
  echo
  echo "  $(basename "$0") cron timestamp"
  echo "    \"timestamp /var/log/uptime.log every 15 minutes\" cron job established"
  echo
}
