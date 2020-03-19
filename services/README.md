# treehouses/cli/services

## About
The treehouses services module relies on install scripts for each individual service.

These install scripts create the necessary docker-compose yml files and contain different information about the service, such as the size of the service and the port it uses.

These install scripts are named `install-<service>.sh` and are located inside the `/services/`directory.

An empty install script is shown [below](#Template).

## Adding a new service
Using the [below](#Template) template, fill in the sections as required.

Look at the pre-existing install scripts in `/services/` for examples.

#### create service directory
Replace `<service>`
```
  mkdir -p /srv/<service>
```
with the name of your service.

Additionally, if your service requires any special commands to be run before being used, add them here.

#### create yml(s)
Add the lines to create your yml file(s).

Replace `<service>/<service>`
```
  } > /srv/<service>/<service>.yml
```
with the name of your service.

#### add autorun


#### add port(s)
Replace `<port>`
```
  echo "<port>"
```
with the port your service uses.

#### add size (in MB)
Replace `<size>`
```
  echo "<size>"
```
with the size of your service in MB.

#### add info
Replace `<url>`
```
  echo "<url>"
```
with the url of your service (eg. GitHub repository).

Replace `<description>`
```
  echo "\"<description>\""
```
with a short description of your service.

#### add svg icon
Replace `<svg icon code>`
```
  <svg icon code>
```
with the svg icon code of your service.

Save the file as `install-<service>.sh` inside the `/services/` directory.

## Template
```
#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/<service>

  # create yml(s)
  {


  } > /srv/<service>/<service>.yml

  # add autorun
  {
    echo "<service>_autorun=true"
    echo
    echo "if [ \"\$<service>_autorun\" = true ]; then"
    echo "  docker-compose -f /srv/<service>/<service>.yml -p <service> up -d"
    echo "fi"
    echo
    echo
  } > /srv/<service>/autorun
}
}

# add port(s)
function get_ports {
  echo "<port>"
}

# add size (in MB)
function get_size {
  echo "<size>"
}

# add info
function get_info {
  echo "<url>"
  echo
  echo "\"<description>\""
}

# add svg icon
function get_icon {
  cat <<EOF
  <svg icon code>
EOF
}
```
