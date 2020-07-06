function check_latest {
  magnum=$2
  wget -q "https://wireframe.raspberrypi.org/issues"
  mv ./issues ./issues.txt
  latest="$(sed -n '186p' issues.txt)"
  rm ./issues.txt
  latest=${latest:25}
  quoteloc="${latest%%\"*}"
  ind=${#quoteloc}
  latest=${latest:0:$ind}
}

function all {
  check_latest
  echo "Fetching all Wireframe magazines..."
  for i in $(seq 1 $latest);
  do
    if [ -f "Wireframe$i.pdf" ]; then
      echo "Wireframe$i.pdf ✓"
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
    wget -q -O "Wireframe$i.pdf" $url
    echo "Wireframe$i.pdf ✓"
  done
}

function latest {
  check_latest
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
  wget -q -O "Wireframe$magnum.pdf" $url
  echo "Wireframe$magnum.pdf ✓"
}

function number {
  check_latest
  magnum=$req
  if [[ $magnum -lt 1 ]] || [[ $magnum -gt $latest ]]; then
    echo "ERROR: Please enter a valid magazine number"
    echo "       This can be any issue ranging from 1 to $latest"
    cd - &>/dev/null
    exit 1
  fi
  if [ -f "Wireframe$magnum.pdf" ]; then
    echo "Wireframe$magnum.pdf already exists, exiting..."
    cd - &>/dev/null
    exit 0
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
  wget -q -O "Wireframe$magnum.pdf" $url
  echo "Wireframe$magnum.pdf ✓"
}

function language {
  echo "The default language for Wireframe is English"
  echo "Currently, Wireframe does not offer issues in any other languages"
  exit 0
}

function info {
  echo "Wireframe is a new fortnightly magazine that lifts the lid on video games. In every issue, we'll be looking at how games are made, who makes them, and even guide you through the process of making your own."
}
