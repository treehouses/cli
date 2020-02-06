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
        logger -p local0.info -t @treehouses/cli "INFO: $1"
        ;;
	  # Stuff might break
      "WARNING")
	    if [[ "$LOG" -gt "1" ]]; then
          logger -p local0.warning -t @treehouses/cli "WARNING: $1"
		fi 
        ;;
	  # Stuff did break
      "ERROR")
	  	if [[ "$LOG" -gt "2" ]]; then
          logger -p local0.err -t @treehouses/cli "ERROR: $1"
		fi
        ;;
	  # Developer wants to log as well
      "DEBUG")
	  	if [[ "$LOG" -gt "3" ]]; then
          logger -p local0.debug -t @treehouses/cli "DEBUG: $1"
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
  local lines="$2"
  case "$1" in
    "")
	  case "$LOG" in
	    "0")
		  logit "log 0: log is disabled"
		  ;;
	    "1")
		  logit "log 1: level is set to Info"
		  ;;
	    "2")
		  logit "log 2: level is set to Info and Warning"
		  ;;
	    "3")
		  logit "log 3: level is set to Info, Warning, and Error"
		  ;;
	    "4")
		  logit "log 4: level is set to Info, Warning, Error, and Debug"
		  ;;
		"max")
		  logit "log X: level is set to max"
		  ;;
	  esac
      exit 0;
      ;;
	"0")
      LOG=0
      logit "log 0: log disabled"
      ;;
    "1")
      LOG=1
      logit "log 1: level set to Info" "" "INFO"
      ;;
    "2")
      LOG=2
      logit "log 2: level set to Info and Warning" "" "WARNING"
      ;;
    "3")
      LOG=3
      logit "log 3: level set to Info, Warning, and Error" "" "ERROR"
      ;;
    "4")
      LOG=4
      logit "log 4: level set to Info, Warning, Error, and Debug" "" "DEBUG"
      ;;
	"show")
	  if [ -z "$2" ]; then
	    lines="6"
	  elif ! [[ "$2" =~ ^[0-9]+$ ]]; then
	    log_and_exit1 "Error: only numbers allowed"
      fi
	  grep "@treehouses/cli" /var/log/syslog | tail -n "$lines"
	  ;;
	"max")
	  LOG=max
	  logit "log X: level set to max" "" "DEBUG"
	  ;;
    *)
      log_and_exit1 "Error: only '0' '1' '2' '3' '4' 'show' 'max' options are supported"
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
  echo "      log 0: log is disabled"
  echo
  echo "  $BASENAME log 0"
  echo "      log 0: log disabled"
  echo
  echo "  $BASENAME log 1"
  echo "      log 1: level set to Info"
  echo
  echo "  $BASENAME log 2"
  echo "      log 2: level set to Info and Warning"
  echo
  echo "  $BASENAME log 3"
  echo "      log 3: level set to Info, Warning, and Error"
  echo
  echo "  $BASENAME log 4"
  echo "      log 4: level set to Info, Warning, Error, and Debug"
  echo
  echo "  $BASENAME log show"
  echo "      Shows the default 6 lines of log which is at (/var/log/syslog)"
  echo "      @treehouses/cli: temperature fahrenheit"
  echo
  echo "  $BASENAME log show 5"
  echo "      Shows 5 lines of log which is at (/var/log/syslog)"
  echo "      @treehouses/cli: temperature fahrenheit"
  echo
  echo "  $BASENAME log max"
  echo "      log X: level set to max"
  echo
}
