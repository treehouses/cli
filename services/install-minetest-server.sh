#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/minetest-server

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
    echo "      - \"/srv/minetest-server:/root/.minetest-server\""
    echo "    restart: unless-stopped"
  } > /srv/minetest-server/minetest-server.yml

  # create .env with default values
  {
    echo "PUID=1000"
    echo "PGID=1000"
    echo "TZ=Europe/London"
    echo "CLI_ARGS=\" --gameid minetest --worldname world\""
  } > /srv/minetest-server/.env

  # add autorun
  {
    echo "minetest-server_autorun=true"
    echo
    echo "if [ \"\$minetest-server_autorun\" = true ]; then"
    echo "  treehouses services minetest-server up"
    echo "fi"
    echo
    echo
  } > /srv/minetest-server/autorun
}

# environment var
function uses_env {
  echo true
}

# add supported arm(s)
function supported_arms {
  echo "v7l"
  echo "v6l"
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
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- https://github.com/minetest/minetest_game/blob/master/LICENSE.txt -->
<!-- Created with Inkscape (http://www.inkscape.org/) -->
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   width="48px"
   height="48px"
   id="svg2856"
   version="1.1"
   inkscape:version="0.47 r22583"
   sodipodi:docname="minetest-icon.svg"
   inkscape:export-filename="/home/erlehmann/pics/icons/minetest/minetest-icon-24x24.png"
   inkscape:export-xdpi="45"
   inkscape:export-ydpi="45">
  <defs
     id="defs2858">
    <filter
       inkscape:collect="always"
       id="filter3864">
      <feGaussianBlur
         inkscape:collect="always"
         stdDeviation="0.20490381"
         id="feGaussianBlur3866" />
    </filter>
  </defs>
  <sodipodi:namedview
     id="base"
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1.0"
     inkscape:pageopacity="0.0"
     inkscape:pageshadow="2"
     inkscape:zoom="12.083333"
     inkscape:cx="24"
     inkscape:cy="24"
     inkscape:current-layer="layer1"
     showgrid="false"
     inkscape:grid-bbox="true"
     inkscape:document-units="px"
     inkscape:window-width="1233"
     inkscape:window-height="755"
     inkscape:window-x="0"
     inkscape:window-y="25"
     inkscape:window-maximized="1">
    <inkscape:grid
       type="xygrid"
       id="grid2866"
       empspacing="2"
       visible="true"
       enabled="true"
       snapvisiblegridlinesonly="true"
       spacingx="0.5px"
       spacingy="10px"
       color="#ff0000"
       opacity="0.1254902"
       empcolor="#ff0000"
       empopacity="0.25098039"
       dotted="false" />
    <inkscape:grid
       type="axonomgrid"
       id="grid2870"
       units="px"
       empspacing="1"
       visible="true"
       enabled="true"
       snapvisiblegridlinesonly="true"
       spacingy="1px"
       originx="0px" />
  </sodipodi:namedview>
  <metadata
     id="metadata2861">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title />
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <g
     id="layer1"
     inkscape:label="Layer 1"
     inkscape:groupmode="layer">
    <path
       style="fill:#e9b96e;fill-opacity:1;stroke:#573a0d;stroke-width:1;stroke-linecap:square;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0"
       d="M 6.1513775e-7,16 3.2110204e-7,28 21.035899,40.145082 l 21,-12.414519 0,-11.461126 L 20.78461,4 6.1513775e-7,16 z"
       id="path3047"
       transform="translate(3.4641013,6)"
       sodipodi:nodetypes="ccccccc" />
    <path
       style="fill:#2e3436;fill-opacity:1;stroke:#2e3436;stroke-width:1;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0"
       d="m 8.5,30.907477 -2,-1.1547 0,6 L 17.320508,42 l 0,-2 -1.732051,-1 0,-2 L 13.5,35.794229 l 0,-4 -5,-2.886752 0,2 z"
       id="path3831"
       sodipodi:nodetypes="ccccccccccc" />
    <path
       style="opacity:1;fill:#555753;fill-opacity:1;stroke:#2e3436;stroke-linejoin:miter"
       d="m 6.9282032,36 3.4641018,-2 3.464101,2 1.643594,0.948929 0,2 2,1.154701 0,2 L 6.9282032,36 z"
       id="path3870"
       sodipodi:nodetypes="cccccccc" />
    <path
       style="fill:#fce94f;fill-opacity:1;stroke:#625802;stroke-width:1;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0"
       d="M 25.980762,19 31.5,22.186533 l 0,2 L 38.09375,28 41.5625,26 45.5,23.730563 l 0,2.538874 0,-4 L 32.908965,15 25.980762,19 z"
       id="path3851"
       sodipodi:nodetypes="cccccccccc" />
    <path
       style="fill:#e9b96e;fill-opacity:1;stroke:#573a0d;stroke-width:1;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0.50000000000000000"
       d="m 24.839746,18.341234 8.660254,-5 0,2 -8.660254,5 0,-2 z"
       id="path5684"
       sodipodi:nodetypes="ccccc" />
    <path
       style="fill:#73d216;fill-opacity:1;stroke:#325b09;stroke-width:1;stroke-linecap:square;stroke-linejoin:round;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0"
       d="M 25.980762,5 3.4641016,18 17.5,26.10363 31.5,18.186533 24.839746,14.341234 33.5,9.341234 25.980762,5 z"
       id="path3821"
       sodipodi:nodetypes="ccccccc"
       transform="translate(0,4)" />
    <path
       style="fill:#729fcf;fill-opacity:1;stroke:#19314b;stroke-width:1;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0"
       d="m 17.5,28.10363 0,2 1.552559,0.89637 0,2 5.447441,3.145082 12,-7.071797 0,-2.14657 2,-1.1547 0,-1.54403 -7,-4.041452 -14,7.917097 z"
       id="path3825"
       sodipodi:nodetypes="ccccccccccc"
       transform="translate(0,4)" />
    <g
       id="g5691"
       style="stroke-linejoin:miter">
      <path
         sodipodi:nodetypes="ccccc"
         id="path3862"
         d="m 13.856406,20 6.928204,4 -6.928204,4 -6.9282028,-4 6.9282028,-4 z"
         style="fill:#2e3436;fill-opacity:1;stroke:none;stroke-width:1;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0;filter:url(#filter3864);opacity:0.25000000000000000" />
      <g
         id="g3858"
         style="stroke-linejoin:miter">
        <path
           style="fill:#c17d11;fill-opacity:1;stroke:#8f5902;stroke-width:1;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0"
           d="m 15.588457,21 1.732051,1 1.732051,-1 0,-6 -1.732051,-1 -1.732051,1 0,6 z"
           id="path3833"
           sodipodi:nodetypes="ccccccc"
           transform="translate(-3.4641015,2)" />
        <path
           style="fill:#4e9a06;fill-opacity:1;stroke:#316004;stroke-width:1;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0"
           d="M 9.9641015,13.752777 17.320508,18 l 6.643593,-3.835681 0,-8.3286385 L 17.320508,2 9.9641015,6.2472233 l 0,7.5055537 z"
           id="path3837"
           transform="translate(-3.4641015,2)"
           sodipodi:nodetypes="ccccccc" />
      </g>
    </g>
    <g
       id="g5686"
       transform="translate(-4.2591582e-7,2)"
       style="stroke-linejoin:miter">
      <path
         transform="translate(24.248712,-2)"
         style="opacity:0.25000000000000000;fill:#2e3436;fill-opacity:1;stroke:none;filter:url(#filter3864);stroke-linejoin:miter"
         d="m 13.856406,20 5.196153,3 -5.196153,3 -5.196152,-3 5.196152,-3 z"
         id="path3868"
         sodipodi:nodetypes="ccccc" />
      <path
         style="fill:#4e9a06;fill-opacity:1;stroke:#316004;stroke-width:1;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0"
         d="M 15.71539,21.073285 17.320508,22 l 1.394882,-0.805336 0,-8.389328 L 17.320508,12 l -1.605118,1.073285 0,8 z"
         id="path3853"
         sodipodi:nodetypes="ccccccc"
         transform="translate(20.78461,0)" />
    </g>
    <path
       style="fill:none;fill-opacity:1;stroke:#ef2929;stroke-width:0.50000000000000000;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:0.50000000000000000, 0.50000000000000000;stroke-dashoffset:0.25000000000000000"
       d="M 12.124356,33 11.25833,32.5"
       id="path3872"
       sodipodi:nodetypes="cc" />
    <path
       style="fill:#888a85;stroke:#2e3436;stroke-width:1;stroke-linecap:round;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none;stroke-dashoffset:0.50000000000000000"
       d="m 45.5,26.730563 -4,2.309401 0,1 -2,1.1547 0,2 -2,1.154701 0,4 8,-4.618802 0,-7 z"
       id="path3874"
       sodipodi:nodetypes="ccccccccc" />
  </g>
</svg>
EOF
}
