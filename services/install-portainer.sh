#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/portainer

  # create yml(s)
  {
    echo "services:"
    echo "  portainer:"
    echo "    image: portainer/portainer:alpine"
    echo "    ports:"
    echo "      - \"9000:9000\""
    echo "    volumes:"
    echo "      - \"/var/run/docker.sock:/var/run/docker.sock\""
    echo "      - \"portainer_data:/data\""
    echo "version: \"2\""
    echo "volumes:"
    echo "  portainer_data:"
  } > /srv/portainer/portainer.yml

  # add autorun
  {
    echo "portainer_autorun=true"
    echo
    echo "if [ \"\$portainer_autorun\" = true ]; then"
    echo "  treehouses services portainer up"
    echo "fi"
    echo
    echo
  } > /srv/portainer/autorun
}

# environment var
function uses_env {
  echo false
}

# add supported arch(es)
function supported_arches {
  echo "aarch64"
  echo "armv7l"
  echo "armv6l"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "9000"
}

# add size (in MB)
function get_size {
  echo "100"
}

# add description
function get_description {
  echo "Portainer is a lightweight management UI for Docker environments"
}

# add info
function get_info {
  echo "https://github.com/portainer/portainer"
  echo
  echo "\"Portainer is a lightweight management UI which allows you to"
  echo "easily manage your different Docker environments (Docker hosts or"
  echo "Swarm clusters).\""
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" role="img" viewBox="-35.15 -42.65 4037.80 1292.80">
  <title>Portainer logo</title>
  <style>svg {enable-background:new 0 0 3960 1208}</style>
  <style>.st16{fill:#38d9fe}.st17{fill:#39d9fe}.st18{fill:#3adafe}</style>
  <path d="M454.5 101c-82.6 48.1-165.6 95.5-248.1 143.8-14 8.2-28.5 12.4-44.7 12.2-28.3-.4-56.6-.1-84.9-.1-5 0-10.1-.1-15.1.3-6.9.6-12.3 2.9-12.6 11.1-.3 8.2 4.8 10.9 11.9 11.5 5.6.5 11.3.4 17 .4 64.2 0 128.3-.1 192.5.1 9.2 0 19.3-2.1 26.9 5.5 6.2 0 12.3.1 18.5.1h54.8c6 0 12 0 18-.1.1-.2.2-.3.3-.5 25.5-10.7 51.8-5.5 77.9-3.5 8 .6 10.6 8 11.7 15.3 1.2 8.1.9 16.3.9 24.5v421.2c0 6.9-.3 13.9.7 20.7 1 6.5 4.6 10.1 11.3 10.4 7.6.3 9.5-4.7 9.9-10.9.5-6.3.3-12.6.3-18.9V322.9c0-8.8-.6-17.7 1.4-26.3 2.5-10.9 9.7-15.7 20.6-15.2 10.1.5 14.1 7 15.3 16 1.1 8.1.8 16.3.8 24.5v438.2c0 12.7-.7 25.5 12.6 33.3 7.7 4.5 13 5.5 13.4-5.9.2-5.7.1-11.3.1-17V324.8c0-5-.1-10.1.1-15.1.6-25.7 4.1-29.7 29.8-29.8 74.9-.4 149.8.2 224.7-.5 9.6-.1 26.7 6.4 26.4-11.3-.3-15.6-16.3-10.1-25.7-10.3-16.8-.4-32.3-3.6-46.9-12.1-82.6-48.3-165.5-96-248.4-143.8-26-15-31.8-37.1-18.3-65.7h-34c13 28.8 6.8 49.7-19.1 64.8zm5.6 150.2c-65.9-.1-131.7 0-197.6 0-.3-1.1-.6-2.3-.9-3.4 69.7-40.3 139.5-80.7 211.9-122.6 0 40.9-.2 78.4.1 115.9.2 10.6-6.3 10.1-13.5 10.1zm48.6-124.9c71.7 41.4 140.9 81.4 210.1 121.3-.1 1.2-.2 2.4-.4 3.5-65.7 0-131.4-.2-197.1.2-10.4.1-12.8-4.7-12.7-13.7.2-35.7.1-71.4.1-111.3z" class="st16"/>
  <path d="M525.9 101.7c82.9 47.8 165.8 95.5 248.4 143.8 14.6 8.5 30.1 11.8 46.9 12.1 9.5.2 25.5-5.3 25.7 10.3.3 17.7-16.8 11.2-26.4 11.3-74.9.7-149.8.1-224.7.5-25.7.1-29.2 4.1-29.8 29.8-.1 5-.1 10.1-.1 15.1v445.7c0 5.7 0 11.3-.1 17-.4 11.4-5.7 10.4-13.4 5.9-13.3-7.8-12.6-20.6-12.6-33.3V321.7c0-8.2.3-16.4-.8-24.5-1.2-9.1-5.3-15.6-15.3-16-10.9-.5-18.2 4.3-20.6 15.2-2 8.7-1.4 17.5-1.4 26.3v421.2c0 6.3.2 12.6-.3 18.9-.5 6.2-2.3 11.2-9.9 10.9-6.7-.3-10.3-3.9-11.3-10.4-1.1-6.9-.7-13.8-.7-20.7V321.4c0-8.2.3-16.4-.9-24.5-1.1-7.3-3.7-14.6-11.7-15.3-26-2-52.4-7.1-77.9 3.5-.1.2-.2.3-.3.5h2.6c20.8.1 41.6 1.6 62.3 0 17.6-1.4 20.4 5.4 20.4 21.3-.6 151.7.2 303.4-.9 455.1-.2 24.3 15.1 17.9 26.8 19 17.2 1.7 8.5-12.4 8.5-18.4.6-149.8.4-299.6.4-449.4 0-5 .2-10.1 0-15.1-.4-8.9 3.9-11.6 12.5-12.3 15.9-1.2 13.1 9.4 13.1 18.6v455.1c0 32.9 2 35.8 36.6 50.2v-21c0-159.9.4-319.8-.5-479.6-.1-20 5.9-23.7 24.3-23.5 79.9 1 159.9.2 239.8.6 13.4.1 21.5-.1 21.7-18.1.2-19.6-10.5-17.2-22.5-17.1-20 .2-39 .3-57.9-11-74.4-44.6-149-89.2-225.4-130.3-30.5-16.4-49.5-33.8-42-70.2.2-1.1-.5-2.4-.8-3.7-13.6 28.8-7.8 50.9 18.2 65.9zm-52.2-31.8c.7 10-2.7 15.7-11.7 20.9-88.9 50.9-177.5 102.2-266 153.7-8.5 5-17.1 6.9-26.8 6.8-37.1-.3-74.2.5-111.3-.4-14.5-.4-14.6 7.2-14.4 17.5.2 9.9-1 18.2 14 18.1 79.2-.7 158.5-.6 237.7-.7h2.1c-7.6-7.6-17.7-5.5-26.9-5.5-64.2-.3-128.3-.1-192.5-.1-5.7 0-11.3.2-17-.4-7.1-.6-12.1-3.3-11.9-11.5.3-8.1 5.6-10.5 12.6-11.1 5-.4 10.1-.3 15.1-.3 28.3 0 56.6-.3 84.9.1 16.3.2 30.7-4 44.7-12.2 82.5-48.3 165.6-95.6 248.1-143.8 25.9-15.1 32.1-36 19.1-65 0 11.3-.6 22.7.2 33.9zm121.1 874.6c10.6-50.6-4.9-92.7-45.5-123.5-38.8-29.4-82.2-33-126.2-11.1-11 5.5-17.6 4.6-26.2-3.4-22.1-20.6-48.5-30.9-74.1-30.6-55.9-.9-100.4 29.1-118.3 77.7-3.9 10.6-8.7 13.8-20.1 14.2-70.3 2.3-121.7 57.7-119 126.9 2.6 66.5 58.8 117.4 127.4 114.1 13.9-.7 21 3.9 28.9 14.7 45.9 62.4 133.9 66.9 185.3 9.7 8.2-9.2 13.3-8.7 23.2-2.4 47.6 30.3 107.7 23.9 147.9-14.5s48.8-99.4 20.1-148.8c-4.5-7.8-5.1-14.7-3.4-23z" class="st16"/>
  <path d="M173.6 849.7c7.1-2.2 12.4-2.7 15-10.6 30.3-89.8 144.2-101.1 201-60.3 11.1 8 14.9 4.9 17.8-6.2 12-45.7 12-90.5-8.2-134.3-4.6-10-10.4-13.6-21.4-13.4-45.9.6-91.8.3-137.8.3-45.3 0-90.6.5-135.9-.3-12-.2-18.2 4-22.7 14.6C56.1 699.8 60.9 757.4 96.7 812c17.8 27.3 38.4 50 76.9 37.7zm614-342.5c0-12.1-.7-21.5.2-30.8 1.2-12.8-2.8-19-16.5-17-4.3.6-8.9.6-13.2 0-13.9-2.1-16.7 4.5-16.4 17.1.7 39.6.3 79.3.3 119 0 95-.1 190.1.1 285.1 0 5.8-3.3 15.4 3.9 16.7 12.1 2.2 25.6 3.1 37.3-.2 8.8-2.5 4.1-14.5 4.1-22 .4-52 .2-103.9.2-159.9 35.5 35.2 73.4 56.7 121.1 53.8 47.2-2.9 85-24.1 114.8-60.6 48.6-59.4 43.9-150.8-11-206.6-61.2-62.4-140.6-61.2-224.9 5.4zm114.9 216.7c-59-.3-111.8-53.8-111.5-112.9.3-60.1 52.3-110.7 113.2-110.3 59.4.4 106.5 50.3 105.8 111.9-.7 61.1-49.5 111.5-107.5 111.3zm2070.1-257.3c-66-25.1-132.9-7.5-178.5 47.1-54.2 64.8-44.7 160.9 21.5 218.1 63.2 54.6 161.3 48.4 215.7-14.2 8.7-10 18.8-19.9 21-34.4-29.2-2.3-53.2.4-78.7 20.1-61.7 47.8-150.7 8.4-163.2-70.2h20.5c74.3 0 148.5-.1 222.8.2 10.9 0 16.9-1 17.1-14.8.9-67.4-38.6-129.3-98.2-151.9zm35.4 121.9c-31.4-.6-62.8-.2-94.2-.2-30.8 0-61.5-.4-92.3.2-11.2.2-12.1-3.3-9.2-13.2 12.7-42.9 55.9-74.7 102.3-74.7 46.3 0 89.8 32 102.5 74.7 3 9.7 2.1 13.4-9.1 13.2zm-833.6-129.1c-29.7-6.2-38.1-.2-38.1 29v20.1c-76.2-78.3-167.8-59.3-221.3-10.4-55 50.3-64 141.1-19.5 203.2 23.2 32.4 53.9 54.5 92.8 63.6 57.7 13.6 105.4-6.7 148-50 0 12.3.9 20.6-.2 28.5-2.2 16.3 4.8 20.2 20.1 19.4 29.8-1.5 25.4 2.9 25.6-26.8.2-32.1.1-64.2.1-96.3 0-54.7.1-109.5-.2-164.2 0-5.8 3.9-13.8-7.3-16.1zM2021 723.9c-57.9 0-106.9-51.1-107.2-111.8-.3-61.4 47.4-111.3 106.6-111.4 61-.2 112.4 50.6 112.4 110.9 0 59.6-52.4 112.3-111.8 112.3zm-775.9-268c-81.2 6.4-147.6 82.4-141.5 162 2.6 87.2 80.5 156.1 163.1 150.9 86.7-5.4 153.7-82.4 147.5-168.7-6.1-86-82.4-151-169.1-144.2zm13.3 267.9c-58.7-.1-108.5-52.4-108-113.3.5-60.6 49.4-110 108.8-109.9 60.1.1 107 48.6 107.1 110.6.1 62.1-48.4 112.8-107.9 112.6zm2512-268.4c-85.2-.6-156.4 71-156.3 156.3.1 84.5 72.3 157.4 156 157.5 82.1-1.2 155.6-66.5 155.8-157.2.2-91.1-71.6-156-155.5-156.6zm-.4 268.4c-59.4-.1-107.7-51-107.4-113.2.3-61.8 47.6-110.1 107.8-110 59.5.1 107.9 49.5 108 110.4.2 61.2-49.6 113-108.4 112.8zM2609.4 459c-49.4-10-95-2.4-135.1 33.7-5-11.4 2.9-25.2-5-30.4-10.8-7.2-25.8-4-38.5-1.8-9.9 1.7-5.8 12.6-5.9 19.4-.3 87.5.6 175.1-.7 262.6-.3 21 9.9 19.8 24 19.6 13.7-.2 25 2.3 24.3-19.3-1.6-52.2-1.3-104.5.4-156.7 1.8-55.5 39.6-86.5 100.4-85.3 47.6 1 72.8 29.8 73.5 85.8.6 52.9.6 105.8 0 158.7-.2 13.2 3.7 18.5 16.9 16.8 4.9-.7 10.1-.5 15.1 0 10.4 1.1 14.4-2.8 14.2-13.7-.7-62.3.3-124.7-1.4-187-1.6-57.1-30.4-91.9-82.2-102.4zM1829 480.1c.4-10.5 2.8-22.4-15-20.8-11.9 1.1-23.9-.6-35.8.4-12.9 1.1-17.8-2.9-17.3-16.6 1-28.3-.3-56.6.6-84.9.4-13.1-3.7-18.7-17-16.9-4.9.6-10.1.7-15.1 0-13.3-1.9-15.9 4.8-15.6 16.4.6 25.1.3 50.3.2 75.5-.2 30.4 3.2 25.8-25.8 26.5-6 .1-14.6-3.3-17.5 3-4.7 10.4-3.2 22.5-1 33.3 1.9 9.3 11.6 4.1 17.7 5.3 1.8.4 3.8.3 5.6 0 16-2.6 22 2.7 21.3 20.1-1.4 36.4-.4 72.9-.4 109.4 0 39 .3 78-.2 117-.1 10.3 2.7 15.5 13.7 14.2 5-.6 10.1-.7 15.1 0 15 2.2 19.1-3.8 18.9-18.7-.8-63.5-.5-127-.2-190.5.1-16.2-6.7-36.9 2.8-47.6 9.9-11 30.9-2.5 47-3.9 1.2-.1 2.5-.1 3.8 0 18.7 2.2 13.8-11.6 14.2-21.2z" class="st16"/>
  <path d="M3290.8 465.2c2-16.8-13.2-9.1-20.5-8.2-30.1 3.8-55.4 18.4-79.4 40.9-3.5-38.7-3.5-37.6-30.4-38.9-15.8-.7-18.6 5.2-18.5 19.3.6 69.2.3 138.4.3 207.6 0 15.7-.2 31.5 0 47.2.5 32.8-5.3 27.4 29.2 28.9 13.8.6 18.5-3 18.3-17.6-.9-49.1-.9-98.1-.1-147.2.9-54.6 32.5-89.7 86.6-95.9 28.7-3.2 13.1-23.9 14.5-36.1z" class="st17"/>
  <path d="M1614.1 456.6c-29.9 5.5-55.6 18.9-77.7 40.5-5.2-4.8-3.8-8.8-3.9-12.3-.7-25.5-.6-25.5-26.9-25.3-1.9 0-3.8.2-5.7 0-9.3-1-13.4 2.2-13.4 12.5.3 92.5.3 185 0 277.5 0 10.4 4.2 13.2 13.5 12.4 5-.4 10.2-.7 15.1 0 14.5 2.2 17.9-4.1 17.7-17.9-.8-47.2-.7-94.4-.2-141.6.6-55.2 26.8-90 79-98.9 21-3.6 23.6-11.6 23.6-29.8 0-17.4-6.3-19.8-21.1-17.1zm1927.5 33.8c-.2-35.8 6.8-29.8-32.3-31.3-13.8-.5-16.6 4.6-16.4 17.2.7 44 .3 87.9.3 131.9v122.5c0 31.2 0 30.2 30.3 31.3 15.5.5 18.6-4.8 18.5-19.2-.6-84 0-168.2-.4-252.4z" class="st16"/>
  <path d="M2329 490.7c0-31.8 0-31.1-32-31.6-13.3-.2-17 3.9-16.8 17 .8 44.6.3 89.2.3 133.8v122.5c0 29.5 0 28.7 30.2 29.7 15.1.5 18.8-4.2 18.7-18.9-.8-84.1-.4-168.3-.4-252.5z" class="st17"/>
  <path d="M371.1 290.8h-.4c.6 20.9 2.3 41.8.6 62.5-2 24.7-22.3 9.2-33.9 11.5-7.6 1.5-23.2 8.1-22.7-11.4.5-20.9.7-41.8 1-62.6h-.4c-5.8.3-11.4-.2-16.4-2.8 4.7 11.7 2.8 24.1 2.9 36.2.3 35.8-.1 71.6.2 107.5.2 19.6 2.2 21.4 21.8 21.6 13.8.2 27.7-.4 41.5.1 14.6.5 20-5.5 19.8-20.1-.5-40.2-.9-80.4-.5-120.6.1-8.3-.8-16.8 2.8-24.6-5 2.5-10.6 3-16.3 2.7zM326 436.4c0 4.7-1.1 9.2-6.9 8.9-5.4-.2-7.1-4.4-7.1-9.2 0-15.7-.1-31.3.2-47 .1-4.4 1.4-9.1 7.3-9 6 .1 6.5 4.8 6.6 9.3.1 8.1 0 16.3 0 24.4-.1 7.6-.1 15.1-.1 22.6zm26.2-22.8v22.7c0 4.7-1.2 9.3-6.8 9.6-5.7.3-7.3-4.1-7.3-8.9-.1-15.7-.1-31.5.1-47.2.1-4.6 1.2-9.3 6.9-9.5 7.4-.2 7 5.8 7.2 10.7.1 7.5-.1 15-.1 22.6zm25.6-26.5c.4 8.7.1 17.5.1 26.3h.4v22.5c0 4.8-1.5 9-7 9.4-6 .5-7.1-4-7.1-8.7-.1-16.3-.1-32.6.1-48.8 0-4 1.6-7.5 6.3-7.7 4.7-.2 7 3.1 7.2 7z" class="st18"/>
  <path d="M384.5 312.7c-.4 40.2-.1 80.4.5 120.6.2 14.6-5.2 20.7-19.8 20.1-13.8-.5-27.6 0-41.5-.1-19.6-.2-21.6-2-21.8-21.6-.3-35.8.1-71.6-.2-107.5-.1-12.1 1.8-24.5-2.9-36.2-1.3-.7-2.5-1.4-3.8-2.4.6 6.8 1.6 13.7 1.7 20.5.2 44.6.6 89.3-.2 133.9-.3 14.2 2.6 20.6 18.5 19.3 18.8-1.5 37.8-1.4 56.5 0 15.6 1.2 18.7-4.9 18.6-19.2-.4-51.5.6-103 1.1-154.5-1.3 1-2.6 1.7-3.9 2.4-3.6 7.9-2.7 16.4-2.8 24.7z" class="st18"/>
  <path d="M371.1 290.8c5.7.3 11.2-.3 16.2-2.7.4-.8.8-1.6 1.3-2.4-6 0-12 0-18 .1 0 1.7.1 3.4.1 5 .2.1.3.1.4 0zm-72.2-2.7c5.1 2.6 10.6 3.1 16.4 2.8h.4c0-1.7 0-3.3.1-5-6.2 0-12.3-.1-18.5-.1.4.4.8.8 1.2 1.3.1.3.3.6.4 1z" class="st18"/>
  <path d="M298.5 287c-.4-.5-.8-.9-1.2-1.3h-2.1c1.2.9 2.5 1.7 3.8 2.4-.2-.4-.4-.7-.5-1.1zm90.2-1.2c-.5.8-.9 1.6-1.3 2.4 1.3-.7 2.6-1.4 3.9-2.4h-2.6z" class="st18"/>
  <path d="M194.2 565.2c0 45.7 0 45.7 45.8 45.7 45.7 0 45.7 0 45.7-46 0-45.7 0-45.7-46-45.7-45.5 0-45.5 0-45.5 46zm28.6 26.2c-.1 4-3 7.2-7.5 6.5-3.3-.5-5.6-3.2-5.7-6.6-.2-8.8-.1-17.6-.1-26.3h-.2c0-8.2-.1-16.3 0-24.5.1-4.1 1.7-7.7 6-8.4 4.6-.8 7.4 2.7 7.4 6.6.4 17.6.4 35.2.1 52.7zm39.1-50.7c0-3.9.7-8.1 5.4-8.4 6.4-.5 6.4 4.7 6.5 9 .2 8.1.1 16.2.1 24.3 0 7.5.2 15 0 22.5-.1 4.2.3 9.9-6 9.4-5.5-.4-6-5.5-6-10v-46.8zm-18.8-8.1c4.9.6 4.5 5.3 4.6 8.8.2 8.1.1 16.2.1 24.3 0 7.5.2 15 0 22.4-.1 4.2.2 9.7-6 9.5-4.2-.2-6-4-6-8.1 0-16.2-.1-32.4 0-48.6 0-4.6 1.5-9 7.3-8.3zm-106-24.1c45.4 0 45.4 0 45.4-46 0-45.9 0-45.9-45.7-45.9-45.6 0-45.6 0-45.6 46.2.1 45.7.1 45.7 45.9 45.7zm20.7-72.6c.1-4.1 3.1-7 7.7-6.4 4.7.6 5.6 4.5 5.6 8.5.1 8.2 0 16.4 0 24.6v24.6c0 4.2-1.8 7.6-6 8.3-4.5.7-7.4-2.7-7.5-6.6-.3-17.8-.2-35.4.2-53zm-25 1.6c0-3.8.9-8 5.9-7.8 4.7.2 5.8 4.1 5.9 8.1.1 8.2 0 16.4 0 24.5v24.5c0 4.2-1.6 7.9-6.1 7.9-4.6 0-5.8-4.1-5.8-8.1 0-16.4-.1-32.7.1-49.1zm-26.1-1c0-3.2 1.1-6.4 5.1-6.7 5-.4 6.4 3.2 6.5 7.2.2 8.2.1 16.3.1 24.5h.1V486c0 4-.6 8-5.3 8.6-4.8.6-6.4-3.2-6.4-7.2-.2-17-.3-34-.1-50.9zm30.3 82.7c-45.8 0-45.8 0-45.8 45.9s0 45.9 45.7 45.9c45.6 0 45.6 0 45.6-45.8.1-46 .1-46-45.5-46zm-18.7 71.9c0 3.3-1.5 6.3-5.2 6.7-5 .5-6.4-3.2-6.5-7.1-.2-9.4-.1-18.8-.1-28.2 0-7.5-.1-15 0-22.6.1-3.9 1.1-8 6-7.8 4.7.2 5.7 4.2 5.8 8.2.1 16.9.1 33.9 0 50.8zm26.3-1.8c0 4.1-1.4 7.7-5.8 8.3-5.2.7-6.1-3.6-6.1-7.3-.2-16.8-.2-33.6 0-50.5 0-3.7.9-8.1 6-7.5 4.3.5 5.8 4.2 5.8 8.3v24.3c0 8.1.2 16.3.1 24.4zm26.4.4c-.1 4.1-1.8 7.6-6.1 8.2-4.6.6-7.3-2.9-7.3-6.8-.3-17.5-.2-35.1.1-52.6.1-3.2 2.2-6 5.8-6.4 4.6-.4 7.1 2.8 7.3 6.8.4 9.4.1 18.8.1 28.2h.2c-.1 7.6 0 15.1-.1 22.6zm68.4-81.2c46.3 0 46.3 0 46.3-47.2 0-44.7 0-44.7-43.5-44.7-48 0-48 0-48 47.5 0 44.4 0 44.4 45.2 44.4zm22.6-72c0-3.3 1.4-6.3 5.2-6.7 5.2-.6 6.4 3.2 6.5 7.1.2 8.2.1 16.3.1 24.5 0 8.8.1 17.6-.1 26.4 0 3.4-1.4 6.5-5.1 6.8-4.7.3-6.5-2.9-6.5-7.2-.2-16.9-.2-33.9-.1-50.9zm-26.2-.1c0-3.3 1.6-6.2 5.2-6.7 5.1-.7 6.4 3.1 6.5 7 .3 8.7.1 17.5.1 26.2 0 8.1.1 16.2 0 24.4-.1 3.9-1.1 8.1-5.9 7.8-4.2-.3-6.1-3.8-6.1-8.1.1-16.9 0-33.7.2-50.6zm-26.5.6c.1-4 1.7-7.5 6.5-7.6 4.8-.1 6.9 3.5 7 7.3.4 17 .4 34 .2 51 0 4-2.2 7.6-6.7 7.6-5.6-.1-7.1-4.4-7.1-9.2-.1-8.2 0-16.4 0-24.6.1-8.1-.1-16.3.1-24.5z" class="st17"/>
  <path fill="#3ad9fe" d="M344.1 610.9c45.8 0 45.8 0 45.8-46.1 0-45.7 0-45.7-46.2-45.7h-1.9c-44.9 0-44.9 0-44.9 45.2 0 46.6 0 46.6 47.2 46.6zm20.4-71.3c.1-3.9 2.2-7.4 6.8-7.5 4.7 0 6.6 3.7 6.8 7.5.4 8.8.1 17.6.1 26.3 0 8.2.3 16.3-.1 24.5-.2 3.8-2.2 7.5-6.8 7.5-4.5-.1-6.7-3.5-6.8-7.5-.3-16.9-.3-33.8 0-50.8zm-26.2.2c.1-3.9 2.1-7.5 6.6-7.7 4.6-.2 6.8 3.4 7 7.3.4 8.1.1 16.3.1 24.5 0 8.8.2 17.6-.1 26.4-.1 4-2.2 7.5-6.6 7.7-4.6.2-6.9-3.5-7-7.3-.3-17-.3-33.9 0-50.9zm-26.2 1.4c.1-4.5 1.5-9.3 7.2-9 5.6.3 6.6 4.9 6.6 9.6.1 8.2 0 16.3 0 24.5 0 6.9.1 13.8 0 20.7-.1 5.1-.4 10.9-7.3 10.8-5.6 0-6.7-5-6.7-9.5 0-15.7-.1-31.4.2-47.1z"/>
  <path d="M3358.7 689.7c-20.7.6-36.4 17.4-36 38.3.4 20.3 17.7 37.4 37.5 37.1 20.5-.3 38.5-19.2 37.6-39.6-.8-19.5-19.2-36.4-39.1-35.8zM2303.4 334.5c-17.5.1-31.1 13.5-31.4 31-.3 17.9 14.5 33.2 31.9 32.9 17.2-.3 32.6-16.2 32.2-33.4-.4-15.9-16.1-30.6-32.7-30.5zm1211.7 0c-17.5.6-30.6 14.3-30.4 31.9.1 18 15.2 32.7 32.7 32 16.2-.7 30.9-16 31.2-32.3.2-16.8-16-32.2-33.5-31.6z" class="st17"/>
</svg>
EOF
}
