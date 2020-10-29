#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/minetest

  # create yml(s)
  {
    echo "version: \"2.1\""
    echo "services:"
    echo "  minetest:"
    echo "    image: linuxserver/minetest:latest"
    echo "    environment:"
    echo "      - PUID=\${PUID}"
    echo "      - PGID=\${PGID}"
    echo "      - TZ=\${TZ}"
    echo "      - CLI_ARGS=\${CLI_ARGS}"
    echo "    ports:"
    echo "      - 30000:30000/udp"
    echo "    volumes:"
    echo "      - \"/srv/minetest:/root/.minetest-server\""
    echo "    restart: unless-stopped"
  } > /srv/minetest/minetest.yml

  # create .env with default values
  {
    echo "PUID=1000"
    echo "PGID=1000"
    echo "TZ=Europe/London"
    echo "CLI_ARGS=\" --gameid minetest --worldname world\""
  } > /srv/minetest/.env

  # add autorun
  {
    echo "minetest_autorun=true"
    echo
    echo "if [ \"\$minetest_autorun\" = true ]; then"
    echo "  treehouses services minetest up"
    echo "fi"
    echo
    echo
  } > /srv/minetest/autorun
}

# environment var
function uses_env {
  echo true
}

# add supported arm(s)
function supported_arms {
  echo "armv7l"
  echo "x86_64"
  echo "aarch64"
}

# add port(s)
function get_ports {
  echo "30000"
}

# add size (in MB)
function get_size {
  echo "22"
}

# add info
function get_info {
  echo "https://www.minetest.net/"
  echo
  echo "Minetest is a free software game engine for voxel-based games. A detailed description can be found at Minetest."
  echo "Minetest usually comes distributed along with one rather simple sandbox-style game by default: Minetest Game."
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48">
  <defs/>
  <defs>
    <filter id="a">
      <feGaussianBlur stdDeviation=".20490381"/>
    </filter>
  </defs>
  <path fill="#e9b96e" stroke="#573a0d" stroke-linecap="square" d="M3.46410192 22l-3e-7 12L24.5000003 46.145082l21-12.414519V22.269437L24.2487113 10 3.46410192 22z"/>
  <path fill="#2e3436" stroke="#2e3436" stroke-linecap="round" d="M8.5 30.907477l-2-1.1547v6L17.320508 42v-2l-1.732051-1v-2L13.5 35.794229v-4l-5-2.886752v2z"/>
  <path fill="#555753" stroke="#2e3436" d="M6.9282032 36l3.4641018-2 3.464101 2L15.5 36.948929v2l2 1.154701v2L6.9282032 36z"/>
  <path fill="#fce94f" stroke="#625802" stroke-linecap="round" stroke-linejoin="round" d="M25.980762 19L31.5 22.186533v2L38.09375 28l3.46875-2L45.5 23.730563v2.538874-4L32.908965 15l-6.928203 4z"/>
  <path fill="#e9b96e" stroke="#573a0d" stroke-dashoffset=".5" stroke-linecap="round" stroke-linejoin="round" d="M24.839746 18.341234l8.660254-5v2l-8.660254 5v-2z"/>
  <path fill="#73d216" stroke="#325b09" stroke-linecap="square" stroke-linejoin="round" d="M25.980762 9L3.4641016 22 17.5 30.10363l14-7.917097-6.660254-3.845299 8.660254-5L25.980762 9z"/>
  <path fill="#729fcf" stroke="#19314b" stroke-linecap="round" d="M17.5 32.10363v2L19.052559 35v2L24.5 40.145082l12-7.071797v-2.14657l2-1.1547v-1.54403l-7-4.041452-14 7.917097z"/>
  <path fill="#2e3436" d="M13.856406 20l6.928204 4-6.928204 4-6.9282028-4 6.9282028-4z" filter="url(#a)" opacity=".25"/>
  <g stroke-linecap="round">
    <path fill="#c17d11" stroke="#8f5902" d="M12.1243555 23l1.732051 1 1.732051-1v-6l-1.732051-1-1.732051 1v6z"/>
    <path fill="#4e9a06" stroke="#316004" d="M6.5 15.752777L13.8564065 20l6.643593-3.835681V7.8356805L13.8564065 4 6.5 8.2472233v7.5055537z"/>
  </g>
  <path fill="#2e3436" d="M13.856406 20l5.196153 3-5.196153 3-5.196152-3 5.196152-3z" filter="url(#a)" opacity=".25" transform="translate(24.24871157)"/>
  <path fill="#4e9a06" stroke="#316004" stroke-linecap="round" d="M36.49999957 23.073285L38.10511757 24l1.394882-.805336v-8.389328L38.10511757 14l-1.605118 1.073285v8z"/>
  <path fill="none" stroke="#ef2929" stroke-dasharray=".5 .5" stroke-dashoffset=".25" stroke-width=".5" d="M12.124356 33l-.866026-.5"/>
  <path fill="#888a85" stroke="#2e3436" stroke-dashoffset=".5" stroke-linecap="round" d="M45.5 26.730563l-4 2.309401v1l-2 1.1547v2l-2 1.154701v4l8-4.618802v-7z"/>
</svg>
EOF
}
