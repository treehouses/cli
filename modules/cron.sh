#!/bin/bash
function cron {
  option="$1"
  #option- add, list, delete, deleteall
  cron_job_file=/etc/cron.d/treehouses
  case "$option" in
      "add")
         freq="$2"
         # freq- hourly daily weekly monthly yearly
         cmd="$3"
         #validate cmd
         if [ -z "$cmd" ]; then
             cron_help
             exit 1
         fi
         # create cron job entry
         # minutes hours days months weeks
         # e.g hourly "30 * * * * root /home/pi/backup.sh >> /home/pi/backup.log"
         schedule=""
         case "$freq" in
             "hourly")
                 schedule="30 * * * *"
                 ;;
             "daily")
                 schedule="30 0 * * *"
                 ;;
             "monthly")
                 schedule="30 0 1 * *"
                 ;;
             "weekly")
                 schedule="30 0 * * 6"
                 ;;
             "yearly")
                 schedule="30 0 1 1 *"
                 ;;
             *)
                 cron_help
                 exit 1
                 ;;
         esac
         cron_entry="$schedule root $cmd"
         echo "$cron_entry" >> $cron_job_file
         echo "added '$cron_entry' "
         ;;
          
      "list")
         if [ -f $cron_job_file ]; then
            echo "ID --- CRON JOB"
            id=1
            while read -r entry; do
                echo "$id - $entry"
                id=$(($id+1))
            done < $cron_job_file
         else
             echo "No cron job found"
         fi
         ;;
      "delete")
          if [ -f $cron_job_file ]; then
              id=$2
              max_id=$"`cat $cron_job_file |wc -l`"
              if [ $id -eq 0 -o $id -gt $max_id ]; then
                  echo "Invalid ID"
                  exit 1
              fi
              sed -i "$id d" $cron_job_file
              echo "Cron job ID $id deleted."
          else
              echo "No cron job found"
          fi
          ;;
      "deleteall")
         echo "" > $cron_job_file 
         ;;
      *)
         cron_help
         exit 1
         ;;
  esac
}

function cron_help {
  echo ""
  echo "Usage: $(basename "$0") cron <add|list|delete|deleteall>"
  echo ""
  echo "Users can execute scheduled commands, such as adding a monthly task, deleting tasks, listing all the scheduled tasks and deleting all the scheduled tasks"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") cron add yearly "echo 'happy birthday, Mike!'""
  echo "  This will schedule a yearly task on the designated date,(e.g March 10th),it will echo 'happy birthday, Mike!'"  
  echo ""
  echo "  $(basename "$0") cron list"
  echo "      This will list all commands user has scheduled."
  echo "  $(basename "$0") cron delete 2"
  echo "      This will delete 2nd commands user has scheduled."
  echo "  $(basename "$0") cron deleteall"
  echo "      This will delete all commands user has scheduled."
  echo ""
}
