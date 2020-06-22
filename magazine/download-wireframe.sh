magnum=$2
wget -q "https://wireframe.raspberrypi.org/issues"
mv ./issues ./issues.txt
latest="$(sed -n '186p' issues.txt)"
rm ./issues.txt
latest=${latest:25}
quoteloc="${latest%%\"*}"
ind=${#quoteloc}
latest=${latest:0:$ind}

function all {
  echo "Fetching all Wireframe magazines..."
  for i in $(seq 1 $latest);
  do
    if [ -f "Wireframe$i.pdf" ]; then
      continue
    fi
    wget -q "https://wireframe.raspberrypi.org/issues/$i/pdf"
    mv ./pdf ./pdf.txt
    url="$(sed -n '10p' pdf.txt)"
    rm ./pdf.txt
    url=${url:44}
    quoteloc="${url%%\"*}"
    ind=${#quoteloc}
    url=${url:0:$ind}
    wget -bqc -O "Wireframe$i.pdf" $url
  done
}

function latest {
  magnum=$latest
  echo "Fetching Wireframe$magnum.pdf..."
  wget -q "https://wireframe.raspberrypi.org/issues/$magnum/pdf"
  mv ./pdf ./pdf.txt
  url="$(sed -n '10p' pdf.txt)"
  rm ./pdf.txt
  url=${url:44}
  quoteloc="${url%%\"*}"
  ind=${#quoteloc}
  url=${url:0:$ind}
  wget -bqc -O "Wireframe$magnum.pdf" $url
  echo "Finished downloading Wireframe$magnum.pdf"
}

function number {
  if [[ $magnum -lt 1 ]] || [[ $magnum -gt $latest ]]; then
    echo "ERROR: Please enter a valid magazine number"
    echo "       This can be any issue ranging from 1 to $latest"
    exit 1
  fi
  if [ -f "Wireframe$magnum.pdf" ]; then
    echo "Wireframe$magnum.pdf already exists, exiting..."
    cd ..
    exit 1
  fi
  echo "Fetching Wireframe$magnum.pdf..."
  wget -q "https://wireframe.raspberrypi.org/issues/$magnum/pdf"
  mv ./pdf ./pdf.txt
  url="$(sed -n '10p' pdf.txt)"
  rm ./pdf.txt
  url=${url:44}
  quoteloc="${url%%\"*}"
  ind=${#quoteloc}
  url=${url:0:$ind}
  wget -bqc -O "Wireframe$magnum.pdf" $url
  echo "Finished downloading Wireframe$magnum.pdf"
}

function info {
  echo "Wireframe is a new fortnightly magazine that lifts the lid on video games. In every issue, we'll be looking at how games are made, who makes them, and even guide you through the process of making your own."
}
