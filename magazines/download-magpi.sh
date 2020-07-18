function check_latest {
  wget -q "https://magpi.raspberrypi.org/issues"
  mv ./issues ./issues.txt
  latest="$(sed -n '219p' issues.txt)"
  rm ./issues.txt
  latest=${latest:25}
  quoteloc="${latest%%\"*}"
  ind=${#quoteloc}
  latest=${latest:0:$ind}
}

function all {
  check_latest
  echo "Fetching all Magpi magazines..."
  for i in $(seq 1 $latest);
  do
    if [ -f "MagPi$i.pdf" ] || [ -f "MagPi0$i.pdf" ]; then
      continue
    fi
    wget -q "https://magpi.raspberrypi.org/issues/$i/pdf"
    mv ./pdf ./pdf.txt
    url="$(sed -n '10p' pdf.txt)"
    rm ./pdf.txt
    url=${url:44}
    quoteloc="${url%%\"*}"
    ind=${#quoteloc}
    url=${url:0:$ind}
    wget -q -O "MagPi$i.pdf" $url
    if [[ $i -lt 10 ]]; then 
      mv "MagPi$i.pdf" "MagPi0$i.pdf" 
      echo "MagPi0$i.pdf ✓"
    else
      echo "MagPi$i.pdf ✓"
    fi 
  done
}

function latest {
  check_latest
  magnum=$latest
  echo "Fetching MagPi$magnum.pdf..."
  wget -q "https://magpi.raspberrypi.org/issues/$magnum/pdf"
  mv ./pdf ./pdf.txt
  url="$(sed -n '10p' pdf.txt)"
  rm ./pdf.txt
  url=${url:44}
  quoteloc="${url%%\"*}"
  ind=${#quoteloc}
  url=${url:0:$ind}
  wget -q -O "MagPi$magnum.pdf" $url
  echo "MagPi$magnum.pdf ✓"
}

function number {
  check_latest
  magnum=$req
  if [[ $magnum -lt 1 ]] || [[ $magnum -gt $latest ]]; then
    echo "ERROR: Please enter a valid magazine number"
    echo "       This can be any issue ranging from 1 to $latest"
    cd - &>/dev/null || return
    exit 1
  fi
  if [ -f "MagPi$magnum.pdf" ] || [ -f "MagPi0$magnum.pdf" ]; then
    echo "File already exists, exiting..."
    cd - &>/dev/null || return
    exit 0
  fi
  echo "Fetching MagPi$magnum.pdf..."
  wget -q "https://magpi.raspberrypi.org/issues/$magnum/pdf"
  mv ./pdf ./pdf.txt
  url="$(sed -n '10p' pdf.txt)"
  rm ./pdf.txt
  url=${url:44}
  quoteloc="${url%%\"*}"
  ind=${#quoteloc}
  url=${url:0:$ind}
  wget -q -O "MagPi$magnum.pdf" $url
  if [[ $magnum -lt 10 ]]; then
    mv "MagPi$magnum.pdf" "MagPi0$magnum.pdf" 
    echo "MagPi0$magnum.pdf ✓"
  else
    echo "MagPi$magnum.pdf ✓"
  fi 
}

function info {
  echo "https://magpi.raspberrypi.org/issues"
  echo
  echo "The MagPi is The Official Raspberry Pi magazine. Written by and for the community, it is packed with Raspberry Pi-themed projects, computing and electronics tutorials, how-to guides, and the latest news and reviews."
}
