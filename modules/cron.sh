#!/bin/bash

function cron {
  options="$1"
  case "$options" in
    ""|"list") #lists current cron tasks
        echo "List of cron jobs:"
      if [[ $(crontab -l | wc -c) -eq 0 ]]; then
        echo "The system has no cron jobs"
      else
        crontab -l
      fi
      ;;
    "add") #add user's cron job to crontab
      cronjob="$2"
      if [[ $(crontab -l | grep "$2") != "$2" ]]; then
        (crontab -l ; echo "$2") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        echo "\"$2\" cron job added"
      elif [[ $(crontab -l | grep "$2") == "$2" ]]; then
        echo "cron job \"$2\" already established"
        echo "run \"$BASENAME help cron\" for more commands"
      fi
      ;;
    "delete") #search for and delete line with it
      crontab -l | grep -q "$2"
      if [ $? -eq 1 ] ; then
        echo "Could not find a job containing \"$2\" to delete"
      else
        (crontab -l ; echo "$2") 2>&1 | grep -v "no crontab" | grep -v "$2" | sort | uniq | crontab -
        echo "cron job(s) containing \"$2\" deleted"
      fi
      ;;
    "deleteall")
      if [[ $(crontab -l | wc -c) -eq 0 ]]; then
        echo "There are no cron jobs to delete"
      else
        crontab -r
        echo "All cron jobs deleted"
      fi
      ;;
    "0W" ) #adds/removes a daily reboot to system - RPi 0's will benefit from this
      if [[ $(crontab -l | grep "@daily") != "@daily reboot" ]]; then
        (crontab -l ; echo "@daily reboot") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        echo "\"Daily Reboot\" cron job established"
      elif [[ $(crontab -l | grep "@daily") == "@daily reboot" ]]; then
        (crontab -l ; echo "@daily reboot") 2>&1 | grep -v "no crontab" | grep -v "@daily" | sort | uniq | crontab -
        echo "\"Daily Reboot\" cron job removed"
      fi
      ;;
    "tor") #add/removes execution of 'tor notice now' every 3 days
      if [[ $(crontab -l | grep tor) != "0 */72 * * * treehouses tor notice now" ]]; then
        (crontab -l ; echo "0 */72 * * * treehouses tor notice now") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        echo "\"treehouses tor notice now\" cron job established"
      elif [[ $(crontab -l | grep tor) == "0 */72 * * * treehouses tor notice now" ]]; then
        (crontab -l ; echo "0 */72 * * * treehouses tor notice now") 2>&1 | grep -v "no crontab" | grep -v "tor" | sort | uniq | crontab -
        echo "\"treehouses tor notice now\" cron job removed"
      fi
      ;;
    "timestamp") #adds/removes timestamp logging every 15 minutes
      #Make log file if not found
      if [ ! -f /var/log/uptime.log ]; then
        sudo touch /var/log/uptime.log
        echo "created \"uptime.log\" in /var/log/"
      fi
      if [[ $(crontab -l | grep date) != "*/15 * * * * date >> /var/log/uptime.log" ]]; then
        (crontab -l ; echo "*/15 * * * * date >> /var/log/uptime.log") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        echo "\"timestamp /var/log/uptime.log every 15 minutes\" cron job established"
      elif [[ $(crontab -l | grep date) == "*/15 * * * * date >> /var/log/uptime.log" ]]; then
        (crontab -l ; echo "*/15 * * * * date >> /var/log/uptime.log") 2>&1 | grep -v "no crontab" | grep -v "date" | sort | uniq | crontab -
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
  echo "Usage: $BASENAME cron [options]    lists all active cron jobs [adds job to cron, or removes it if present]"
  echo
  echo "options:"
  echo "  list                        lists all cron jobs"
  echo "  add <\"cron job\">            see \"HOW TO ADD A CRON JOB\" below"
  echo "  delete <\"word/phrase\">      deletes the cron job matching the word or phrase in quotes"
  echo "  deleteall                   deletes all cron jobs"
  echo "  0W                          creates a daily reboot task (for RPi Zero W)"
  echo "  tor                         sends \"tor notice now\" every 72 hours"
  echo "  timestamp                   creates /var/log/uptime.log, logging every 15 minutes"
  echo
  echo
  echo "HOW TO ADD A CRON JOB:"
  echo "  set the frequency (shown below) of when you want the job to execute followed by the command"
  echo "  example: $BASENAME cron add \"*/15 6-8 * 3 * uname\""
  echo "           This will execute \"uname\" at every 15th minute within the hours of 6 through 8 in March"
  echo "  Frequency Method: * * * * * command-to-execute"
  echo "                    │ │ │ │ │"
  echo "                    │ │ │ │ └── day of the week    (* | #/# | 0 - 6 or Sun to Sat)"
  echo "                    │ │ │ └──── month              (* | #/# | 1 - 12)"
  echo "                    │ │ └────── day of the month   (* | #/# | 1 - 31)"
  echo "                    │ └──────── hour               (* | #/# | 0 - 23)"
  echo "                    └────────── minute             (* | #/# | 0 - 59)"
  echo
  echo "examples:"
  echo "  $BASENAME cron"
  echo "    List of cron jobs:"
  echo "    0 */72 * * * treehouses tor notice now"
  echo "    */15 * * * * date >> /var/log/uptime.log"
  echo "    @daily reboot"
  echo
  echo "  $BASENAME cron 0W"
  echo "    \"daily reboot\" cron job removed"
  echo
  echo "  $BASENAME cron delete \"uname -n\""
  echo "    cron job(s) containing \"uname -n\" deleted"
  echo
}
