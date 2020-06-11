function all {
  exit 0
}

function latest {
  wget -q "https://hackspace.raspberrypi.org/issues"
  mv ./issues ./issues.txt
  latest="$(sed -n '189p' issues.txt)"
  rm ./issues.txt
  latest=${latest:25}
  quoteloc="${latest%%\"*}"
  ind=${#quoteloc}
  latest=${latest:0:$ind}
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
  wget -bqc -O "HackSpace$magnum.pdf" $url
  echo "Finished downloading HackSpace$magnum.pdf"
}

function number {
  exit 0
}

function info {
  echo "HackSpace magazine is packed with projects for fixers and tinkerers of all abilities. We'll teach you new techniques and give you refreshers on familiar ones, from 3D printing, laser cutting, and woodworking to electronics and Internet of Things."
}

$1
