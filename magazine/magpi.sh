function all {
  exit 0
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
  if [[ $req -lt 1 ]] || [[ $req -gt $latest ]]; then
    echo "ERROR: Please enter a valid magazine number"
    echo "       This can be any issue ranging from 1 to $latest"
    exit 1
  fi
}

function number {
  exit 0  
}

function info {
  echo "The MagPi is The Official Raspberry Pi magazine. Written by and for the community, it is packed with Raspberry Pi-themed projects, computing and electronics tutorials, how-to guides, and the latest news and reviews."
}

$1
