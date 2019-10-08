#!/bin/bash
  #temp file will store crontab scripts, which when selected will be written to the temp file.
  #The contents of the temp file will be pushed to cron

function cron {

  #files
  cronjobs=./cronjoblist.sh
  makecronlist=$(sudo touch $cronjobs)
  logfile=./uptime.log
  makelogfile=$(sudo touch $logfile)

  #Make files if not found
  if [ ! -f ${logfile} ]; then
    ${makelogfile}
  fi
  if [ ! -f ${cronjobs} ]; then
    ${makecronlist}
    echo "#!/bin/bash/" >> ${cronjobs}
  fi

  #commands
  cronlist=$(crontab -l)
  cronjoblist=$(cat ${cronjobs})
  grepreboot=$(${cronlist} | grep reboot)
  greptor=$(${cronlist} | grep tor)
  greptimelog=$(${cronlist} | grep uptime.log)

  #cron specific commands
  start0Wcron=$(echo "@daily reboot now" >> cronjoblist.sh)
  stop0Wcron=$(sed -i -e '/reboot/d' cronjoblist.sh)
  starttorcron=$(echo "0 */72 * * * treehouses tor notice now" >> cronjoblist.sh)
  stoptorcron=$(sed -i -e '/tor/d' cronjoblist.sh)
  starttimestamp=$(echo "15 * * * * date >> /var/log/uptime.log" >> cronjoblist.sh)
  stoptimestamp=$(sed -i -e '/date/d' cronjoblist.sh)

  options="$1"
  case "$options" in
    "") #lists current cron tasks
        echo "List of cron jobs:"
      if [ $(crontab -l | wc -c) -eq 0 ]; then
        echo "The system has no cron jobs" ; echo
      else
        echo ${cronjoblist} ; echo
      fi
      ;;

    "0W") #adds/removes a daily reboot to system - RPi 0's will benefit from this
      if [ ${grepreboot}==null ]; then
        ${start0Wcron}
        echo "\"Daily Reboot\" cron job established" ; echo
      elif [ ${grepreboot} ]; then
        ${stop0Wcron}
        echo "\"Daily Reboot\" cron job removed" ; echo
      fi
      ;;

    "tor") #add/removes execution of 'tor notice now' every 3 days
      if [ ${greptor}==null ]; then
        ${starttorcron}
        echo "\"treehouses tor notice now\" will now execute every 72 hours" ; echo
      elif [ ${greptor} ]; then
        ${stoptorcron}
        echo "\"treehouses tor notice now\" will no longer execute every 72 hours" ; echo
      fi
      ;;

    "timestamp") #adds/removes timestamp logging every 15 minutes
      if [ ${greptimelog}==null ]; then
        ${timestamp}
        echo "/var/log/uptime.log will have a timestamp every 15 minutes" ; echo
      elif [ ${greptimelog} ]; then
        ${untimestamp}
        echo "cron timestamping stopped" ; echo
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
  echo "Usage: $(basename "$0") cron [0W|tor|timestamp]                   lists all active cron jobs [adds job to cron, or removes it i$  echo "  Options:"
  echo "    0W           Creates a daily reboot task; Needed for RPi Zero W"
  echo "    tor          Sends \"tor notice now\" every 72 hours"
  echo "    timestamp    Creates /var/log/uptime.log, logging every 15 minutes"
  echo
  echo "Examples:"
  echo "$(basename "$0") cron"
  echo "  List of cron jobs:"
  echo "    0 */72 * * * treehouses tor notice now"
  echo "    15 * * * * echo \"date >> /var/log/uptime.log\""
  echo "    0 0 * * * reboot now"
  echo
  echo "$(basename "$0") cron 0W"
  echo "  \"Daily Reboot\" cron job established"
  echo
  echo "$(basename "$0") cron timestamp"
  echo "  cron timestamping stopped and uptime.log removed from /var/log/" ; echo
  echo
}
