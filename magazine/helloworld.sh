function all {
  exit 0
}

function latest {
  wget -q "https://helloworld.raspberrypi.org/issues"
  mv ./issues ./issues.txt
  latest="$(sed -n '146p' issues.txt)"
  rm ./issues.txt
  latest=${latest:25}
  quoteloc="${latest%%\"*}"
  ind=${#quoteloc}
  latest=${latest:0:$ind}
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
  exit 0
}

function info {
  echo "HelloWorld is the computing and digital making magazine for educators."
}

$1
