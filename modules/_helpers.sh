#!/bin/bash

TREEHOUSES_LOGFILE=${HOME}/treehouses.log

function _date_now {
    date +'%F %H:%M:%S'
}


function _log_command {
    now=$(_date_now)
    echo -e "${now}\t$0 $*" >> $TREEHOUSES_LOGFILE
}
