#!/bin/bash

DATAMB=${1:-128}
FILENM=~/test.dat
[ -f /flash/config.txt ] && CONFIG=/flash/config.txt || CONFIG=/boot/config.txt

trap "rm -f ${FILENM}" EXIT

[ "$(whoami)" == "root" ] || { echo "Must be run as root!"; exit 1; }

WRCMD="rm -f ${FILENM} && sync && dd if=/dev/zero of=${FILENM} bs=1M count=${DATAMB} conv=fsync 2>&1 | grep -v records"
RDCMD="echo 3 > /proc/sys/vm/drop_caches && sync && dd if=${FILENM} of=/dev/null bs=1M 2>&1 | grep -v records"

getperfmbs()
{
  local cmd="${1}" fcount="${2}" ftime="${3}" bormb="${4}"
  local result count _time perf

  result="$(eval "${cmd}")"
  count="$(echo "${result}" | awk "{print \$${fcount}}")"
  _time="$(echo "${result}" | awk "{print \$${ftime}}")"
  if [ "${bormb}" == "MB" ]; then
    perf="$(echo "${count}" "${_time}" | awk '{printf("%0.2f", $1/$2)}')"
  else
    perf="$(echo "${count}" "${_time}" | awk '{printf("%0.2f", $1/$2/1024/1024)}')"
  fi
  echo "${perf}"
  echo "${result}" 
}

  clear
  sync

  echo
  echo "WRITE:"
  WR1="$(getperfmbs "${WRCMD}" 1 ${DDTIME} B)"

  echo
  echo "READ:"
  RD1="$(getperfmbs "${RDCMD}" 1 ${DDTIME} B)"
