#!/bin/bash

# uses logger command to log to /var/log/syslog 
# logit "text" "whether or not to write to screen" "logging level"
# e.g. logit "i logged some text"
# e.g. logit "error: MISSION ABORT" "" "ERROR"
# e.g. logit "i am in the log but not written to terminal window" "1"
# What gets logged depends on the logging level set by log command
function logit() {
  if [[ ! "$LOG" == "0" && ! "$LOG" == "max" ]]; then
    case "$3" in
      "")
        logger -p local0.info -t @treehouses/cli "$1"
        ;;
	  # Stuff might break
      "WARNING")
	    if [[ "$LOG" -gt "1" ]]; then
          logger -p local0.warning -t @treehouses/cli "$1"
		fi 
        ;;
	  # Stuff did break
      "ERROR")
	  	if [[ "$LOG" -gt "2" ]]; then
          logger -p local0.err -t @treehouses/cli "$1"
		fi
        ;;
	  # Developer wants to log as well
      "DEBUG")
	  	if [[ "$LOG" -gt "3" ]]; then
          logger -p local0.debug -t @treehouses/cli "$1"
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

function log_and_exit1() {
  logit "$1" "$2" "$3"
  exit 1
}

# Sets logging level to be used by the entire app
# Can also show the log
function log {
  case "$1" in
    "")
	  case "$LOG" in
	    "0")
		  logit "Log 0: log is disabled"
		  ;;
	    "1")
		  logit "Log 1: level is set to Info"
		  ;;
	    "2")
		  logit "Log 2: level is set to Info and Warning"
		  ;;
	    "3")
		  logit "Log 3: level is set to Info, Warning, and Error"
		  ;;
	    "4")
		  logit "Log 4: level is set to Info, Warning, Error, and Debug"
		  ;;
		"max")
		  logit "Log X: level is set to max"
		  ;;
	  esac
      exit 0;
      ;;
	"0")
      LOG=0
      logit "Log 0: log disabled"
      ;;
    "1")
      LOG=1
      logit "Log 1: level set to Info"
      ;;
    "2")
      LOG=2
      logit "Log 2: level set to Info and Warning"
      ;;
    "3")
      LOG=3
      logit "Log 3: level set to Info, Warning, and Error"
      ;;
    "4")
      LOG=4
      logit "Log 4: level set to Info, Warning, Error, and Debug"
      ;;
	"show")
	  grep "@treehouses/cli" /var/log/syslog
	  ;;
	"max")
	  LOG=max
	  logit "Log X: level set to max"
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
  echo "Usage: $BASENAME log <0|1|2|3|4|show|max>"
  echo
  echo "Example:"
  echo "  $BASENAME log"
  echo "      Log 0: log is disabled"
  echo
  echo "  $BASENAME log 0"
  echo "      Log 0: log disabled"
  echo
  echo "  $BASENAME log 1"
  echo "      Log 1: level set to Info"
  echo
  echo "  $BASENAME log 2"
  echo "      Log 2: level set to Info and Warning"
  echo
  echo "  $BASENAME log 3"
  echo "      Log 3: level set to Info, Warning, and Error"
  echo
  echo "  $BASENAME log 4"
  echo "      Log 4: level set to Info, Warning, Error, and Debug"
  echo
  echo "  $BASENAME log show"
  echo "      @treehouses/cli: temperature fahrenheit"
  echo
  echo "  $BASENAME log max"
  echo "      Log X: level set to max"
  echo
}
