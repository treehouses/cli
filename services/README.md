# treehouses/cli/services

## About
The treehouses services module relies on install scripts for each individual service.

These install scripts create the necessary docker-compose yml file(s) and contain different information about the service, such as the size of the service and the port it uses.

These install scripts are named `install-<service>.sh` and are located inside the `/services/`directory.

Look at the pre-existing install scripts in `/services/` for examples.

An empty install script is shown [below](#Template).

## Adding a new service
Using the [template](#Template), fill in the sections as required.

1. create service directory

   Replace `<service>` with the name of your service.
   ```
     mkdir -p /srv/<service>
   ```

   Additionally, if your service requires any special commands to be run before being used, add them here.

2. create yml(s)

   Add your yml file(s).

   Replace `<service>/<service>` with the name of your service.
   ```
     } > /srv/<service>/<service>.yml
   ```

3. add autorun

   Replace `<service>`s with the name of your service.
   ```
   {
     echo "<service>_autorun=true"
     echo
     echo "if [ \"\$<service>_autorun\" = true ]; then"
     echo "  docker-compose -f /srv/<service>/<service>.yml -p <service> up -d"
     echo "fi"
     echo
     echo
   } > /srv/<service>/autorun
   ```

4. add port(s)

   Replace `<port>` with the port(s) your service uses.
   
   If your service uses multiple ports, add each port on their own individual lines.
   ```
     echo "<port>"
   ```

5. add size (in MB)

   Replace `<size>` with the size of your service in MB (leave out the MB units).
   ```
     echo "<size>"
   ```

6. add info

   Replace `<url>` with the url of your service (eg. GitHub repository).
   ```
     echo "<url>"
   ```

   Replace `<description>` with a short description of your service.
   ```
     echo "\"<description>\""
   ```

7. add svg icon

   Replace `<svg icon code>` with the svg icon code of your service.

   Note that `EOF` cannot have any whitespace in front of it.
   ```
     cat <<EOF
   <svg icon code>
   EOF
   ```

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
