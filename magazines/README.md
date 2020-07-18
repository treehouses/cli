# treehouses/cli/magazines

## About
The `treehouses magazines` module relies on download scripts for each individual RasberryPi magazine.

These download scripts utilize `wget` to fetch the specified magazine in the form of a PDF file for viewing purposes.

These donwload scripts are named `download-<magtype>.sh` and are located in the `/magazines/` directory.

Look at the pre-existing download scripts in `/magazines/` for examples.

Once magazines are downloaded, they are saved in the `~/Documents/` directory.

An empty download script is shown [below](#Template).

## Adding a new magazine
Using the [template](#Template), fill in the sections as required.

1. check for the latest issue number of your magazine
  
   Replace `<line-num>` with the line number in the `issues.txt` file where the latest magazine issue number is found.
   ```
   latest="$(sed -n '<line-num>p' issues.txt)"
   ```

1. create function for fetching all issues of your magazine

   Iterate through each available issue of the magazine.

   `<magtype-lowercase>` should be the same string as `<magtype>` (e.g. magpi).

   `<magtype-uppercase>` refers to the formal name of `<magtype>`  (e.g. MagPi).

   Replace `<magtype-uppercase>` with the name of the magazine and how it will be saved as a PDF file.

   Replace `<magtype-lowercase>` with the name of the magazine and how it appears in the URL, also represents the name of the directory.

   ```
   check_latest
   magnum=$latest
   echo "Fetching <magtype-uppercase>$magnum.pdf..."
   wget -q "https://<magtype-lowercase>.raspberrypi.org/issues/$magnum/pdf"
   ...
   ```

1. create function for fetching the latest issue of your magazine

   Download only the latest issue of the magazine.

   See the steps above for replacing `<magtype-uppercase>` and `<magtype-lowercase>` where needed.

1. create function for fetching a specific issue of the magazine

   Download only the requested issue number of the magazine.

   See the steps above for replacing `<magtype-uppercase>` and `<magtype-lowercase>` where needed.

1. add info

   Replace `<description>` with a short description of your magazine.

   ```
   echo "<description>"
   ```

1. add URL

   Replace `<url>` with the homepage URL of your magazine.

   ```
   echo "<url>"
   ```

Save the file as `download-<magtype>.sh` inside the `/magazines/` directory.

## Template
```
function check_latest {
  wget -q "https://<magtype-lowercase>.raspberrypi.org/issues"
  mv ./issues ./issues.txt
  latest="$(sed -n '<line-num>p' issues.txt)"
  rm ./issues.txt
  latest=${latest:25}
  quoteloc="${latest%%\"*}"
  ind=${#quoteloc}
  latest=${latest:0:$ind}
}

function all {
  check_latest
  echo "Fetching all <magtype-uppercase> magazines..."
  for i in $(seq 1 $latest);
  do
    if [ -f "<magtype-uppercase>$i.pdf" ]; then
      echo "<magtype-uppercase>$i.pdf ✓"
      continue
    fi
    wget -q "https://<magtype-lowercase>.raspberrypi.org/issues/$i/pdf"
    mv ./pdf ./pdf.txt
    url="$(sed -n '10p' pdf.txt)"
    rm ./pdf.txt
    url=${url:44}
    quoteloc="${url%%\"*}"
    ind=${#quoteloc}
    url=${url:0:$ind}
    wget -q -O "<magtype-uppercase>$i.pdf" $url
    echo "<magtype-uppercase>$i.pdf ✓"
  done
}

function latest {
  check_latest
  magnum=$latest
  echo "Fetching <magtype-uppercase>$magnum.pdf..."
  wget -q "https://<magtype-lowercase>.raspberrypi.org/issues/$magnum/pdf"
  mv ./pdf ./pdf.txt
  url="$(sed -n '10p' pdf.txt)"
  rm ./pdf.txt
  url=${url:44}
  quoteloc="${url%%\"*}"
  ind=${#quoteloc}
  url=${url:0:$ind}
  wget -q -O "<magtype-uppercase>$magnum.pdf" $url
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
  if [ -f "<magtype-uppercase>$magnum.pdf" ]; then
    echo "<magtype-uppercase>$magnum.pdf already exists, exiting..."
    cd - &>/dev/null || return
    exit 0
  fi
  echo "Fetching <magtype-uppercase>$magnum.pdf..."
  wget -q "https://<magtype-lowercase>.raspberrypi.org/issues/$magnum/pdf"
  mv ./pdf ./pdf.txt
  url="$(sed -n '10p' pdf.txt)"
  rm ./pdf.txt
  url=${url:44}
  quoteloc="${url%%\"*}"
  ind=${#quoteloc}
  url=${url:0:$ind}
  wget -q -O "<magtype-uppercase>$magnum.pdf" $url
}

function info {
  echo "<description>"
}

function url {
  echo "<url>"
}
```
