function all {
  exit 0
}

function latest {
  wget -q "https://wireframe.raspberrypi.org/issues"
  mv ./issues ./issues.txt
  latest="$(sed -n '186p' issues.txt)"
  rm ./issues.txt
  latest=${latest:25}
  quoteloc="${latest%%\"*}"
  ind=${#quoteloc}
  latest=${latest:0:$ind}
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
  exit 0
}

function info {
  echo "Wireframe is a new fortnightly magazine that lifts the lid on video games. In every issue, we'll be looking at how games are made, who makes them, and even guide you through the process of making your own."
}

$1
