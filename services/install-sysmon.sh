#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/sysmon

  # create yml(s)
  cat << EOF > /srv/sysmon/sysmon.yml
version: '3'
services:
  sysmon:
    image: treehouses/sysmon
    build:
      network: host
      pid: host
EOF

#  # create .env with default values
#  {
#    echo "EXAMPLE_VAR="
#  } > /srv/<service>/.env

  # add autorun
  cat << EOF > /srv/sysmon/autorun
sysmon_autorun=true

if [ "$<service>_autorun" = true ]; then
  treehouses services <service> up
fi


EOF
}

# environment var
function uses_env {
  echo false
}

# add supported arch(es)
function supported_arms {
  echo "armv6l"
  echo "armv7l"
  echo "aarch64"
}

# add port(s)
function get_ports {
  echo "6969"
}

# add size (in MB)
function get_size {
  echo "293"
}

# add info
function get_info {
  echo "https://github.com/t0xic0der/sysmon"
  echo
  echo "\"Sysmon is an intuitive remotely-accessible system performance monitoring and task management tool for servers and headless Raspberry Pi setups\""
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cc="http://creativecommons.org/ns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape" width="1024" height="1024" viewBox="0 0 270.93333 270.93333" version="1.1" id="svg8" inkscape:version="0.92.1 r15371" sodipodi:docname="monitor_white.svg" inkscape:export-filename="/home/a/Bureau/icon3.png" inkscape:export-xdpi="96" inkscape:export-ydpi="96" enable-background="new">
  <defs id="defs2">
    <linearGradient inkscape:collect="always" id="linearGradient4737">
      <stop style="stop-color:#666666;stop-opacity:1;" offset="0" id="stop4733"/>
      <stop style="stop-color:#b3b3b3;stop-opacity:1" offset="1" id="stop4735"/>
    </linearGradient>
    <marker inkscape:stockid="Arrow1Lstart" orient="auto" refY="0.0" refX="0.0" id="Arrow1Lstart" style="overflow:visible" inkscape:isstock="true">
      <path id="path4649" d="M 0.0,0.0 L 5.0,-5.0 L -12.5,0.0 L 5.0,5.0 L 0.0,0.0 z " style="fill-rule:evenodd;stroke:#000000;stroke-width:1.0pt" transform="scale(0.8) translate(12.5,0)"/>
    </marker>
    <inkscape:perspective sodipodi:type="inkscape:persp3d" inkscape:vp_x="-116.62555 : 40.425553 : 1" inkscape:vp_y="0 : 1000 : 0" inkscape:vp_z="270.93333 : 135.46667 : 1" inkscape:persp3d-origin="135.46667 : 90.31111 : 1" id="perspective4531"/>
    <radialGradient inkscape:collect="always" xlink:href="#linearGradient4522" id="radialGradient4528" cx="135.77303" cy="0.89891279" fx="135.77303" fy="0.89891279" r="110.06358" gradientTransform="matrix(-1.3955109,1.5400496,-1.6616176,-1.5397362,326.51325,-220.09139)" gradientUnits="userSpaceOnUse"/>
    <linearGradient inkscape:collect="always" id="linearGradient4522">
      <stop style="stop-color:#000000;stop-opacity:1;" offset="0" id="stop4518"/>
      <stop id="stop4526" offset="0.08821987" style="stop-color:#000000;stop-opacity:0.74901961;"/>
      <stop id="stop4524" offset="0.50174522" style="stop-color:#000000;stop-opacity:0.49803922;"/>
      <stop style="stop-color:#000000;stop-opacity:0;" offset="1" id="stop4520"/>
    </linearGradient>
    <linearGradient inkscape:collect="always" xlink:href="#linearGradient4737" id="linearGradient4741" x1="123.51574" y1="188.19785" x2="146.82983" y2="188.58969" gradientUnits="userSpaceOnUse"/>
  </defs>
  <sodipodi:namedview id="base" pagecolor="#ffffff" bordercolor="#666666" borderopacity="1.0" inkscape:pageopacity="0.0" inkscape:pageshadow="2" inkscape:zoom="0.55048947" inkscape:cx="73.628613" inkscape:cy="419.6769" inkscape:document-units="px" inkscape:current-layer="layer5" showgrid="false" units="px" width="1024px" inkscape:window-width="1678" inkscape:window-height="972" inkscape:window-x="0" inkscape:window-y="26" inkscape:window-maximized="1" inkscape:snap-bbox="true" inkscape:snap-grids="true" inkscape:snap-to-guides="false" inkscape:lockguides="false" showguides="true" inkscape:guide-bbox="true" inkscape:object-paths="false" inkscape:snap-bbox-edge-midpoints="true"/>
  <metadata id="metadata5">
    <rdf:RDF>
      <cc:Work rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/>
        <dc:title/>
        <cc:license rdf:resource="http://creativecommons.org/publicdomain/zero/1.0/"/>
      </cc:Work>
      <cc:License rdf:about="http://creativecommons.org/publicdomain/zero/1.0/">
        <cc:permits rdf:resource="http://creativecommons.org/ns#Reproduction"/>
        <cc:permits rdf:resource="http://creativecommons.org/ns#Distribution"/>
        <cc:permits rdf:resource="http://creativecommons.org/ns#DerivativeWorks"/>
      </cc:License>
    </rdf:RDF>
  </metadata>
  <g inkscape:groupmode="layer" id="layer4" inkscape:label="Calque 4" style="display:inline" sodipodi:insensitive="true">
    <path style="color:#000000;font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:medium;line-height:normal;font-family:sans-serif;font-variant-ligatures:normal;font-variant-position:normal;font-variant-caps:normal;font-variant-numeric:normal;font-variant-alternates:normal;font-feature-settings:normal;text-indent:0;text-align:start;text-decoration:none;text-decoration-line:none;text-decoration-style:solid;text-decoration-color:#000000;letter-spacing:normal;word-spacing:normal;text-transform:none;writing-mode:lr-tb;direction:ltr;text-orientation:mixed;dominant-baseline:auto;baseline-shift:baseline;text-anchor:start;white-space:normal;shape-padding:0;clip-rule:nonzero;display:inline;overflow:visible;visibility:visible;opacity:0.98999999;isolation:auto;mix-blend-mode:normal;color-interpolation:sRGB;color-interpolation-filters:linearRGB;solid-color:#000000;solid-opacity:1;vector-effect:none;fill:#808080;fill-opacity:1;fill-rule:nonzero;stroke:#808080;stroke-width:10.30200005;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;paint-order:stroke fill markers;color-rendering:auto;image-rendering:auto;shape-rendering:auto;text-rendering:auto;enable-background:accumulate" d="m 87.425922,196.97817 c -1.258381,0.005 -3.103989,1.30946 -3.316654,2.54339 l -1.773789,10.2919 c -0.212665,1.23393 1.020092,2.26713 2.278479,2.26713 H 186.24175 c 1.25839,0 2.49771,-1.03435 2.27848,-2.26713 0,0 -1.23629,-6.95172 -1.85442,-10.42759 -0.21923,-1.23278 -1.81488,-2.79922 -3.07326,-2.79435 -32.05556,0.12404 -64.11107,0.26267 -96.166628,0.38665 z" id="rect4647-6" inkscape:connector-curvature="0" sodipodi:nodetypes="sssssssss"/>
  </g>
  <g style="display:inline" inkscape:label="Copie de Calque 4" id="g4529" inkscape:groupmode="layer" sodipodi:insensitive="true">
    <path sodipodi:nodetypes="sssssssss" inkscape:connector-curvature="0" id="path4527" d="m 87.286208,196.64185 c -1.26374,0.004 -3.117206,1.15657 -3.330776,2.24641 l -1.781344,9.09018 c -0.21357,1.08986 1.024436,2.00241 2.288182,2.00241 h 102.06056 c 1.26374,0 2.50833,-0.91357 2.28816,-2.00241 0,0 -1.24155,-6.14001 -1.8623,-9.21001 -0.22017,-1.08886 -1.8226,-2.47238 -3.08636,-2.46809 -32.19206,0.10954 -64.38406,0.23201 -96.576122,0.34151 z" style="color:#000000;font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:medium;line-height:normal;font-family:sans-serif;font-variant-ligatures:normal;font-variant-position:normal;font-variant-caps:normal;font-variant-numeric:normal;font-variant-alternates:normal;font-feature-settings:normal;text-indent:0;text-align:start;text-decoration:none;text-decoration-line:none;text-decoration-style:solid;text-decoration-color:#000000;letter-spacing:normal;word-spacing:normal;text-transform:none;writing-mode:lr-tb;direction:ltr;text-orientation:mixed;dominant-baseline:auto;baseline-shift:baseline;text-anchor:start;white-space:normal;shape-padding:0;clip-rule:nonzero;display:inline;overflow:visible;visibility:visible;opacity:1;isolation:auto;mix-blend-mode:normal;color-interpolation:sRGB;color-interpolation-filters:linearRGB;solid-color:#000000;solid-opacity:1;vector-effect:none;fill:#333333;fill-opacity:1;fill-rule:nonzero;stroke:#333333;stroke-width:9.41981792;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;paint-order:stroke fill markers;color-rendering:auto;image-rendering:auto;shape-rendering:auto;text-rendering:auto;enable-background:accumulate"/>
  </g>
  <g inkscape:groupmode="layer" id="layer3" inkscape:label="Calque 3" style="display:inline" sodipodi:insensitive="true">
    <path style="fill:none;stroke:#000000;stroke-width:2.06500006;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1" d="M 122.73202,199.99714 H 148.2013 Z" id="path4626" inkscape:connector-curvature="0"/>
    <rect style="display:inline;opacity:0.98999999;fill:#666666;stroke:none;stroke-width:1.9874568;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1;paint-order:stroke fill markers" id="rect4624" width="25.469278" height="22.540266" x="122.73203" y="176.92772"/>
  </g>
  <g inkscape:groupmode="layer" id="layer7" inkscape:label="Calque 7" style="display:inline;opacity:0.472" sodipodi:insensitive="true">
    <rect style="display:inline;opacity:0.98999999;fill:url(#linearGradient4741);fill-opacity:1;stroke:none;stroke-width:1.9874568;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1;paint-order:stroke fill markers" id="rect4624-7" width="25.469278" height="22.540266" x="122.73203" y="176.92772"/>
  </g>
  <g inkscape:groupmode="layer" id="layer5" inkscape:label="Calque 5" style="display:inline">
    <rect style="display:inline;opacity:0.98999999;fill:#f9f9f9;fill-opacity:1;stroke:#666666;stroke-width:7.06237888;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1;paint-order:stroke fill markers" id="rect4485-5" width="255.00246" height="163.86629" x="7.9654365" y="8.2232809"/>
  </g>
  <g inkscape:label="Calque 1" inkscape:groupmode="layer" id="layer1" transform="translate(0,-26.066667)" style="display:inline;opacity:1" sodipodi:insensitive="true">
    <rect style="opacity:0.98999999;fill:none;stroke:#333333;stroke-width:7.31291819;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1;paint-order:stroke fill markers" id="rect4485-3" width="261.9014" height="171.07066" x="4.5159678" y="30.839874"/>
  </g>
  <g inkscape:groupmode="layer" id="layer6" inkscape:label="Calque 6" style="display:none;opacity:0.60100002" sodipodi:insensitive="true">
    <rect style="display:inline;opacity:0.98999999;fill:url(#radialGradient4528);fill-opacity:1;stroke:#666666;stroke-width:7.06237888;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1;paint-order:stroke fill markers" id="rect4485" width="255.00246" height="163.86629" x="7.9654365" y="8.2232895"/>
  </g>
  <g inkscape:groupmode="layer" id="layer10" inkscape:label="Calque 11" style="display:inline" sodipodi:insensitive="true"/>
</svg>
EOF
}