magnum=$2
wget -q "https://helloworld.raspberrypi.org/issues"
mv ./issues ./issues.txt
latest="$(sed -n '146p' issues.txt)"
rm ./issues.txt
latest=${latest:25}
quoteloc="${latest%%\"*}"
ind=${#quoteloc}
latest=${latest:0:$ind}

function all {
  echo "Fetching all HelloWorld magazines..."
  for i in $(seq 1 $latest);
  do
    if [ -f "HelloWorld$i.pdf" ]; then
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
    wget -bqc -O "HelloWorld$i.pdf" $url
  done
}

function latest {
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
  wget -bqc -O "HelloWorld$magnum.pdf" $url
  echo "Finished downloading HelloWorld$magnum.pdf"
}

function number {
  if [[ $magnum -lt 1 ]] || [[ $magnum -gt $latest ]]; then
    echo "ERROR: Please enter a valid magazine number"
    echo "       This can be any issue ranging from 1 to $latest"
    exit 1
  fi
  if [ -f "HelloWorld$magnum.pdf" ]; then
    echo "HelloWorld$magnum.pdf already exists, exiting..."
    cd ..
    exit 1
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
  wget -bqc -O "HelloWorld$magnum.pdf" $url
  echo "Finished downloading HelloWorld$magnum.pdf"
}

function info {
  echo "HelloWorld is the computing and digital making magazine for educators."
}
