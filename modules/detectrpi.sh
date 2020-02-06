#!/bin/bash

function detectrpi {
  declare -A rpimodels
  rpimodels["Beta"]="BETA"
  rpimodels["0002"]="RPIB"
  rpimodels["0003"]="RPIB"
  rpimodels["0004"]="RPIB"
  rpimodels["0005"]="RPIB"
  rpimodels["0006"]="RPIB"
  rpimodels["0007"]="RPIA"
  rpimodels["0008"]="RPIA"
  rpimodels["0009"]="RPIA"
  rpimodels["000d"]="RPIB"
  rpimodels["000e"]="RPIB"
  rpimodels["000f"]="RPIB"
  rpimodels["0010"]="RPIB+"
  rpimodels["0011"]="CM"
  rpimodels["0012"]="RPIA+"
  rpimodels["0013"]="RPIB+"
  rpimodels["0014"]="CM"
  rpimodels["0015"]="RPIA+"
  rpimodels["a01040"]="RPI2B"
  rpimodels["a01041"]="RPI2B"
  rpimodels["a21041"]="RPI2B"
  rpimodels["a22042"]="RPI2B"
  rpimodels["900021"]="RPIA+"
  rpimodels["900032"]="RPIB+"
  rpimodels["900092"]="RPIZ"
  rpimodels["900093"]="RPIZ"
  rpimodels["920093"]="RPIZ"
  rpimodels["9000c1"]="RPIZW"
  rpimodels["a02082"]="RPI3B"
  rpimodels["a020a0"]="CM3"
  rpimodels["a22082"]="RPI3B"
  rpimodels["a32082"]="RPI3B"
  rpimodels["a020d3"]="RPI3B+"
  rpimodels["9020e0"]="RPI3A+"
  rpimodels["a03111"]="RPI4B" # 1gb
  rpimodels["b03111"]="RPI4B" # 2gb
  rpimodels["c03111"]="RPI4B" # 4gb
  rpimodels["c03112"]="RPI4B" # 4gb

  rpimodel=$(grep Revision /proc/cpuinfo | sed 's/.* //g' | tr -d '\n')

  found=0
  for i in "${!rpimodels[@]}";
  do
    if [ "$i" == "$rpimodel" ];
    then
      found=1
      break
    fi
  done

  if [ "$found" == 1 ];
  then
    echo ${rpimodels[$rpimodel]}
  else
    echo "nonrpi"
  fi
}


function detectrpi_help {
  echo
  echo "Usage: $BASENAME detectrpi"
  echo
  echo "Detects the hardware version"
  echo
  echo "Example:"
  echo "  $BASENAME detectrpi"
  echo "      Prints the model number"
  echo
}
