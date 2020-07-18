function check_latest {
  wget -q "https://helloworld.raspberrypi.org/issues"
  mv ./issues ./issues.txt
  latest="$(sed -n '146p' issues.txt)"
  rm ./issues.txt
  latest=${latest:25}
  quoteloc="${latest%%\"*}"
  ind=${#quoteloc}
  latest=${latest:0:$ind}
}

function all {
  check_latest
  echo "Fetching all HelloWorld magazines..."
  for i in $(seq 1 $latest);
  do
    if [ -f "HelloWorld$i.pdf" ] || [ -f "HelloWorld0$i.pdf" ]; then
      continue
    fi
    wget -q "https://helloworld.raspberrypi.org/issues/$i/pdf"
    mv ./pdf ./pdf.txt
    url="$(sed -n '10p' pdf.txt)"
    rm ./pdf.txt
    url=${url:44}
    quoteloc="${url%%\"*}"
    ind=${#quoteloc}
    url=${url:0:$ind}
    wget -q -O "HelloWorld$i.pdf" $url
    if [[ $magnum -lt 10 ]]; then 
      mv HelloWorld$i.pdf HackSpace0$i.pdf
      echo "HelloWorld0$i.pdf ✓"
    else
      echo "HelloWorld$i.pdf ✓"
    fi 
  done
}

function latest {
  check_latest
  magnum=$latest
  echo "Fetching HelloWorld$magnum.pdf..."
  wget -q "https://helloworld.raspberrypi.org/issues/$magnum/pdf"
  mv ./pdf ./pdf.txt
  url="$(sed -n '10p' pdf.txt)"
  rm ./pdf.txt
  url=${url:44}
  quoteloc="${url%%\"*}"
  ind=${#quoteloc}
  url=${url:0:$ind}
  wget -q -O "HelloWorld$magnum.pdf" $url
  echo "HelloWorld$magnum.pdf ✓"
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
  if [ -f "HelloWorld$magnum.pdf" ] || [ -f "HelloWorld0$magnum.pdf" ]; then
    echo "File already exists, exiting..."
    cd - &>/dev/null || return
    exit 0
  fi
  echo "Fetching HelloWorld$magnum.pdf..."
  wget -q "https://helloworld.raspberrypi.org/issues/$magnum/pdf"
  mv ./pdf ./pdf.txt
  url="$(sed -n '10p' pdf.txt)"
  rm ./pdf.txt
  url=${url:44}
  quoteloc="${url%%\"*}"
  ind=${#quoteloc}
  url=${url:0:$ind}
  wget -q -O "HelloWorld$magnum.pdf" $url
  echo "HelloWorld$magnum.pdf ✓"
  if [[ $magnum -lt 10 ]]; then 
    mv HelloWorld$magnum.pdf HackSpace0$magnum.pdf
    echo "HelloWorld0$magnum.pdf ✓"
  else
    echo "HelloWorld$magnum.pdf ✓"
  fi 
}

function info {
  echo "https://helloworld.raspberrypi.org/issues"
  echo
  echo "HelloWorld is the computing and digital making magazine for educators."
}
