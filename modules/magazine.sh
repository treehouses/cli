function magazine() {
  checkargn $# 2
  checkinternet
  magtype="$1"
  req="$2"
  magnum="0"
  if [ -z "$magtype" ]; then
    echo "ERROR: no magazine type given"
    exit 1
  fi
  if [ "$magtype" = "magpi" ]; then
    if [ "$req" = "" ]; then
      echo "The MagPi is The Official Raspberry Pi magazine. Written by and for the community, it is packed with Raspberry Pi-themed projects, computing and electronics tutorials, how-to guides, and the latest news and reviews."
      exit 0
    elif [[ "$req" =~ ^[0-9]+$ ]] || [[ "$req" = "latest" ]]; then
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
      magnum=$req
      if [ "$req" = "latest" ]; then
        magnum=$latest
      fi
      if [ ! -d "$magtype" ]; then
        mkdir $magtype
      fi
      cd $magtype || return
      if [ -f "MagPi$magnum.pdf" ]; then
        echo "MagPi$magnum.pdf already exists, exiting..."
        cd ..
        exit 1
      fi
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
      echo "Issue $magnum is saved in the $magtype directory"
      cd ..
    elif [[ "$req" = "all" ]]; then
      if [ ! -d "$magtype" ]; then
        mkdir $magtype
      fi
      cd $magtype || return
      wget -q "https://magpi.raspberrypi.org/issues"
      mv ./issues ./issues.txt
      latest="$(sed -n '219p' issues.txt)"
      rm ./issues.txt
      latest=${latest:25}
      quoteloc="${latest%%\"*}"
      ind=${#quoteloc}
      latest=${latest:0:$ind}
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
      echo "All current issues of magpi are saved in the $magtype directory"
      cd ..
    else
      magazine_help
    fi
  elif [ "$magtype" = "hackspace" ]; then
    if [ "$req" = "" ]; then
      echo "HackSpace magazine is packed with projects for fixers and tinkerers of all abilities. We'll teach you new techniques and give you refreshers on familiar ones, from 3D printing, laser cutting, and woodworking to electronics and Internet of Things."
      exit 0
    elif [[ "$req" =~ ^[0-9]+$ ]] || [[ "$req" = "latest" ]]; then
      wget -q "https://hackspace.raspberrypi.org/issues"
      mv ./issues ./issues.txt
      latest="$(sed -n '189p' issues.txt)"
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
      magnum=$req
      if [ "$req" = "latest" ]; then
        magnum=$latest
      fi
      if [ ! -d "$magtype" ]; then
        mkdir $magtype
      fi
      cd $magtype || return
      if [ -f "HackSpace$magnum.pdf" ]; then
        echo "HackSpace$magnum.pdf already exists, exiting..."
        cd ..
        exit 1
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
      wget -bqc -O "HackSpace$magnum.pdf" $url
      echo "Finished downloading HackSpace$magnum.pdf"
      echo "Issue $magnum is saved in the $magtype directory"
      cd ..
    elif [[ "$req" = "all" ]]; then
      if [ ! -d "$magtype" ]; then
        mkdir $magtype
      fi
      cd $magtype || return
      wget -q "https://hackspace.raspberrypi.org/issues"
      mv ./issues ./issues.txt
      latest="$(sed -n '189p' issues.txt)"
      rm ./issues.txt
      latest=${latest:25}
      quoteloc="${latest%%\"*}"
      ind=${#quoteloc}
      latest=${latest:0:$ind}
      echo "Fetching all HackSpace magazines..."
      for i in $(seq 1 $latest);
      do
        if [ -f "HackSpace$i.pdf" ]; then
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
        wget -bqc -O "HackSpace$i.pdf" $url
      done
      echo "All current issues of hackspace are saved in the $magtype directory"
      cd ..
      else
      magazine_help
    fi
  elif [ "$magtype" = "wireframe" ]; then
    if [ "$req" = "" ]; then
      echo "Wireframe is a new fortnightly magazine that lifts the lid on video games. In every issue, we'll be looking at how games are made, who makes them, and even guide you through the process of making your own."
      exit 0
    elif [[ "$req" =~ ^[0-9]+$ ]] || [[ "$req" = "latest" ]]; then
      wget -q "https://wireframe.raspberrypi.org/issues"
      mv ./issues ./issues.txt
      latest="$(sed -n '186p' issues.txt)"
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
      magnum=$req
      if [ "$req" = "latest" ]; then
        magnum=$latest
      fi
      if [ ! -d "$magtype" ]; then
        mkdir $magtype
      fi
      cd $magtype || return
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
      echo "Issue $magnum is saved in the $magtype directory"
      cd ..
    elif [[ "$req" = "all" ]]; then
      if [ ! -d "$magtype" ]; then
        mkdir $magtype
      fi
      cd $magtype || return
      wget -q "https://wireframe.raspberrypi.org/issues"
      mv ./issues ./issues.txt
      latest="$(sed -n '186p' issues.txt)"
      rm ./issues.txt
      latest=${latest:25}
      quoteloc="${latest%%\"*}"
      ind=${#quoteloc}
      latest=${latest:0:$ind}
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
      echo "All current issues of wireframe are saved in the $magtype directory"
      cd ..
    else
      magazine_help
    fi
  else
    echo "Please specify a valid magazine type, these include: magpi, hackspace, wireframe"
  fi
}

function magazine_help {
  echo
  echo "  Usage:"
  echo
  echo "    $BASENAME magazine <hackspace|magpi|wireframe> [all|latest|number]"
  echo "        This downloads the specified issue of a magazine as a pdf with filename <mag_type>#.pdf based on user input"
  echo
  echo "  Examples:"
  echo
  echo "    $BASENAME magazine magpi"
  echo "        This will print out details about the magpi magazine."
  echo
  echo "    $BASENAME magazine magpi all"
  echo "        This will download all the currently present issues of magpi."
  echo
  echo "    $BASENAME magazine magpi latest"
  echo "        This will download the latest issue of magpi."
  echo
  echo "    $BASENAME magazine magpi number"
  echo "        This will download issue [number] of magpi."
  echo
}
