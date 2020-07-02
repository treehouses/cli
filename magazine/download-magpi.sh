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
    if [ -f "MagPi$i.pdf" ]; then
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
}

function number {
  check_latest
  magnum=$req
  if [[ $magnum -lt 1 ]] || [[ $magnum -gt $latest ]]; then
    echo "ERROR: Please enter a valid magazine number"
    echo "       This can be any issue ranging from 1 to $latest"
    exit 1
  fi
  if [ -f "MagPi$magnum.pdf" ]; then
    echo "MagPi$magnum.pdf already exists, exiting..."
    cd ..
    exit 1
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
}

function language {
  echo "English (default), French, Hebrew, Italian, Spanish"
}

function info {
  echo "The MagPi is The Official Raspberry Pi magazine. Written by and for the community, it is packed with Raspberry Pi-themed projects, computing and electronics tutorials, how-to guides, and the latest news and reviews."
}
