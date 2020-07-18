function check_latest {
  wget -q "https://hackspace.raspberrypi.org/issues"
  mv ./issues ./issues.txt
  latest="$(sed -n '189p' issues.txt)"
  rm ./issues.txt
  latest=${latest:25}
  quoteloc="${latest%%\"*}"
  ind=${#quoteloc}
  latest=${latest:0:$ind}
}

function all {
  check_latest
  echo "Fetching all HackSpace magazines..."
  for i in $(seq 1 $latest);
  do
    if [ -f "HackSpace$i.pdf" ] || [ -f "HackSpace0$i.pdf" ]; then
      continue
    fi
    wget -q "https://hackspace.raspberrypi.org/issues/$i/pdf"
    mv ./pdf ./pdf.txt
    url="$(sed -n '10p' pdf.txt)"
    rm ./pdf.txt
    url=${url:44}
    quoteloc="${url%%\"*}"
    ind=${#quoteloc}
    url=${url:0:$ind}
    wget -q -O "HackSpace$i.pdf" $url
    if [[ $i -lt 10 ]]; then 
      mv HackSpace$i.pdf HackSpace0$i.pdf
      echo "HackSpace0$i.pdf ✓"
    else
      echo "HackSpace$i.pdf ✓"
    fi 
  done
}

function latest {
  check_latest
  magnum=$latest
  echo "Fetching HackSpace$magnum.pdf..."
  wget -q "https://hackspace.raspberrypi.org/issues/$magnum/pdf"
  mv ./pdf ./pdf.txt
  url="$(sed -n '10p' pdf.txt)"
  rm ./pdf.txt
  url=${url:44}
  quoteloc="${url%%\"*}"
  ind=${#quoteloc}
  url=${url:0:$ind}
  wget -q -O "HackSpace$magnum.pdf" $url
  echo "HackSpace$magnum.pdf ✓"
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
  if [ -f "HackSpace$magnum.pdf" ] || [ -f "HackSpace0$magnum.pdf" ];  then
    echo "File already exists, exiting..."
    cd - &>/dev/null || return
    exit 0
  fi
  echo "Fetching HackSpace$magnum.pdf..."
  wget -q "https://hackspace.raspberrypi.org/issues/$magnum/pdf"
  mv ./pdf ./pdf.txt
  url="$(sed -n '10p' pdf.txt)"
  rm ./pdf.txt
  url=${url:44}
  quoteloc="${url%%\"*}"
  ind=${#quoteloc}
  url=${url:0:$ind}
  wget -q -O "HackSpace$magnum.pdf" $url
  if [[ $magnum -lt 10 ]]; then 
    mv HackSpace$magnum.pdf HackSpace0$magnum.pdf
    echo "HackSpace0$magnum.pdf ✓"
  else
    echo "HackSpace$magnum.pdf ✓"
  fi 
}

function info {
  echo "https://hackspace.raspberrypi.org/issues"
  echo
  echo "HackSpace magazine is packed with projects for fixers and tinkerers of all abilities. We'll teach you new techniques and give you refreshers on familiar ones, from 3D printing, laser cutting, and woodworking to electronics and Internet of Things."
}
