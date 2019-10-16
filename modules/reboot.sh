#!/bin/bash

function reboot {
  case "$1" in
    "")
      echo "No timeframe selected" ; echo
      reboot_help
      ;;
    "now")
      echo "Rebooting now."
      sudo reboot
      ;;
    "in")
      echo "Rebooting in \"$2\". ctrl+c to cancel."
      sleep "$2" ; sudo reboot
      ;;
    "cron")
      if [[ $(crontab -l | grep "$2" ) != "$2 reboot" ]]; then
        (crontab -l ; echo "$2 reboot") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        echo "Rebooting with frequency or \"$2\" added"
      elif [[ $(crontab -l | grep "$2") == "$2 reboot" ]]; then
        echo "Reboot frequency of \"$2\" already established"
        echo "To delete it, use: $(basename "$0") cron delete \"$2\""
      else
        reboot_help
      fi
      ;;
    "daily")
      if [[ $(crontab -l | grep "@daily") != "@daily reboot" ]]; then
        (crontab -l ; echo "@daily reboot") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        echo "System will reboot daily at 00:00"
      elif [[ $(crontab -l | grep "@daily") == "@daily reboot" ]]; then
        (crontab -l ; echo "@daily reboot") 2>&1 | grep -v "no crontab" | grep -v "@daily" | sort | uniq | crontab -
        echo "Job to reboot daily removed"
      else
        reboot_help
      fi
      ;;
    "weekly")
      if [[ $(crontab -l | grep "@weekly") != "@weekly reboot" ]]; then
        (crontab -l ; echo "@weekly reboot") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        echo "System will reboot at 00:00 every Sunday"
      elif [[ $(crontab -l | grep "@weekly") == "@weekly reboot" ]]; then
        (crontab -l ; echo "@weekly reboot") 2>&1 | grep -v "no crontab" | grep -v "@weekly" | sort | uniq | crontab -
        echo "Job to reboot weekly removed"
      else
        reboot_help
      fi
      ;;
    "monthly")
      if [[ $(crontab -l | grep "@monthly") != "@monthly reboot" ]]; then
        (crontab -l ; echo "@monthly reboot") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        echo "System will reboot at 00:00 on the 1st of every month"
      elif [[ $(crontab -l | grep "@monthly") == "@monthly reboot" ]]; then
        (crontab -l ; echo "@monthly reboot") 2>&1 | grep -v "no crontab" | grep -v "@monthly" | sort | uniq | crontab -
        echo "Job to reboot monthly removed"
      else
        reboot_help
      fi
      ;;
    "*")
      echo "Invalid input"
      reboot_help
      ;;
  esac
}

function reboot_help {
  echo ""
  echo "  Usage: $(basename "$0") reboot <now|in|cron|daily|weekly|monthly>"
  echo ""
  echo "  Reboots system at selected time"
  echo ""
  echo "  Example:"
  echo "  $(basename "$0") reboot daily"
  echo "  System will reboot daily at 00:00"
  echo ""
  echo "  $(basename "$0") reboot in 120"
  echo "  System will reboot in 120 seconds. ctrl+c to cancel."
  echo ""
  echo "  $(basename "$0") reboot cron \"0 * * * *\""
  echo "  cron job with frequency \"0 * * * *\" added"
  echo ""
  echo "  Set frequency: * * * * *"
  echo "                 │ │ │ │ │"
  echo "                 │ │ │ │ └── day of the week    (* | #/# | 0 - 6 or Sun to Sat)"
  echo "                 │ │ │ └──── month              (* | #/# | 1 - 12)"
  echo "                 │ │ └────── day of the month   (* | #/# | 1 - 31)"
  echo "                 │ └──────── hour               (* | #/# | 0 - 23)"
  echo "                 └────────── minute             (* | #/# | 0 - 59)"
  echo ""
}
