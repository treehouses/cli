#!/bin/bash

# uses logger command to log to /var/log/syslog 
# logit "text" "whether or not to write to screen" "logging level"
# e.g. logit "i logged some text"
# e.g. logit "error: MISSION ABORT" "" "ERROR"
# e.g. logit "i am in the log but not written to terminal window" "1"
# What gets logged depends on the logging level set by log command
function logit() {
  $s1 = "$(basename "$0"):"
  if [[ ! "$LOG" == "0" ]]; then
    case "$3" in
      "")
        logger -p local0.info "$s1$1"
        ;;
	  # Stuff might break
      "WARNING")
	    if [[ "$LOG" -gt "1" ]]; then
          logger -p local0.warning "$s1$1"
		fi 
        ;;
	  # Stuff did break
      "ERROR")
	  	if [[ "$LOG" -gt "2" ]]; then
          logger -p local0.err "$s1$1"
		fi
        ;;
	  # Developer wants to log as well
      "DEBUG")
	  	if [[ "$LOG" -gt "3" ]]; then
          logger -p local0.debug "$s1$1"
		fi
        ;;
    esac
	sync;
  fi
  if [[ "$2" == "1" ]]; then
    return 0;
  fi
  echo "$1"
}

# Sets logging level to be used by the entire app
# Can also show the log
function log {
  case "$1" in
    "")
	  case "$LOG" in
	    "0")
		  logit "Log is disabled"
		  ;;
	    "1")
		  logit "Log level is set to Info"
		  ;;
	    "2")
		  logit "Log level is set to Info and Warning"
		  ;;
	    "3")
		  logit "Log level is set to Info, Warning, and Error"
		  ;;
	    "4")
		  logit "Log level is set to Info, Warning, Error, and Debug"
		  ;;
	  esac
      exit 0;
      ;;
	"0")
      LOG=0
      logit "Log disabled"
      ;;
    "1")
      LOG=1
      logit "Log level set to Info"
      ;;
    "2")
      LOG=2
      logit "Log level set to Info and Warning"
      ;;
    "3")
      LOG=3
      logit "Log level set to Info, Warning, and Error"
      ;;
    "4")
      LOG=4
      logit "Log level set to Info, Warning, Error, and Debug"
      ;;
	"show")
	  grep "$(basename "$0")" /var/log/syslog
	  ;;
    *)
      echo "Error: option not supported";
      exit 1;
      ;;
  esac
  conf_var_update "LOG" "$LOG"
}

function log_help {
  echo
  echo "Usage: $(basename "$0") log <0|1|2|3|4|show>"
  echo
  echo "Example:"
  echo "  $(basename "$0") log"
  echo "      Log is disabled"
  echo
  echo "  $(basename "$0") log 0"
  echo "      Log disabled"
  echo
  echo "  $(basename "$0") log 1"
  echo "      Log level set to Info"
  echo
  echo "  $(basename "$0") log 2"
  echo "      Log level set to Info and Warning"
  echo
  echo "  $(basename "$0") log 3"
  echo "      Log level set to Info, Warning, and Error"
  echo
  echo "  $(basename "$0") log 4"
  echo "      Log level set to Info, Warning, Error, and Debug"
  echo
  echo "  $(basename "$0") log show"
  echo "      treehouses pi: cli.sh: execution started with 'log 1' arguments"
  echo
}
