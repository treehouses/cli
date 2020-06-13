function all {
  wget -q "https://magpi.raspberrypi.org/issues"
  mv ./issues ./issues.txt
  latest="$(sed -n '219p' issues.txt)"
  rm ./issues.txt
  latest=${latest:25}
  quoteloc="${latest%%\"*}"
  ind=${#quoteloc}
  latest=${latest:0:$ind}
  magnum=$latest
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
    wget -bqc -O "MagPi$i.pdf" $url
  done
}

function latest {
  wget -q "https://magpi.raspberrypi.org/issues"
  mv ./issues ./issues.txt
  latest="$(sed -n '219p' issues.txt)"
  rm ./issues.txt
  latest=${latest:25}
  quoteloc="${latest%%\"*}"
  ind=${#quoteloc}
  latest=${latest:0:$ind}
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
  wget -bqc -O "MagPi$magnum.pdf" $url
  echo "Finished downloading MagPi$magnum.pdf"
}

function number {
  exit 0  
}

function info {
  echo "The MagPi is The Official Raspberry Pi magazine. Written by and for the community, it is packed with Raspberry Pi-themed projects, computing and electronics tutorials, how-to guides, and the latest news and reviews."
}

$1
