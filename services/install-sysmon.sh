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
    network_mode: "host"
    #using port 6969
    pid: "host"
EOF

#  # create .env with default values
#  {
#    echo "EXAMPLE_VAR="
#  } > /srv/<service>/.env

  # add autorun
  cat << EOF > /srv/sysmon/autorun
sysmon_autorun=true

if [ "$sysmon_autorun" = true ]; then
  treehouses services sysmon up
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

# add description
function get_description {
  echo "Sysmon is an intuitive system performance monitoring and task management tool for servers"
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
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 270.93333 270.93333">
  <defs/>
  <defs>
    <linearGradient id="b">
      <stop offset="0" stop-color="#666"/>
      <stop offset="1" stop-color="#b3b3b3"/>
    </linearGradient>
    <linearGradient id="a">
      <stop offset="0"/>
      <stop offset=".08821987" stop-opacity=".74901961"/>
      <stop offset=".50174522" stop-opacity=".49803922"/>
      <stop offset="1" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="c" x1="123.51574" x2="146.82983" y1="188.19785" y2="188.58969" gradientUnits="userSpaceOnUse" xlink:href="#b"/>
    <radialGradient id="d" cx="135.77303" cy=".89891279" r="110.06358" fx="135.77303" fy=".89891279" gradientTransform="matrix(-1.39551 1.54005 -1.66162 -1.53974 326.51325 -220.09139)" gradientUnits="userSpaceOnUse" xlink:href="#a"/>
  </defs>
  <path style="line-height:normal;font-variant-ligatures:normal;font-variant-position:normal;font-variant-caps:normal;font-variant-numeric:normal;font-variant-alternates:normal;font-feature-settings:normal;text-indent:0;text-align:start;text-decoration-line:none;text-decoration-style:solid;text-decoration-color:#000;text-transform:none;text-orientation:mixed;white-space:normal;shape-padding:0;isolation:auto;mix-blend-mode:normal;solid-color:#000;solid-opacity:1" fill="gray" stroke="gray" stroke-linecap="round" stroke-linejoin="round" stroke-width="10.30200005" d="M87.425922 196.97817c-1.258381.005-3.103989 1.30946-3.316654 2.54339l-1.773789 10.2919c-.212665 1.23393 1.020092 2.26713 2.278479 2.26713H186.24175c1.25839 0 2.49771-1.03435 2.27848-2.26713 0 0-1.23629-6.95172-1.85442-10.42759-.21923-1.23278-1.81488-2.79922-3.07326-2.79435-32.05556.12404-64.11107.26267-96.166628.38665z" color="#000" font-family="sans-serif" font-weight="400" opacity=".98999999" overflow="visible" paint-order="stroke fill markers"/>
  <path d="M87.286208 196.64185c-1.26374.004-3.117206 1.15657-3.330776 2.24641l-1.781344 9.09018c-.21357 1.08986 1.024436 2.00241 2.288182 2.00241h102.06056c1.26374 0 2.50833-.91357 2.28816-2.00241 0 0-1.24155-6.14001-1.8623-9.21001-.22017-1.08886-1.8226-2.47238-3.08636-2.46809-32.19206.10954-64.38406.23201-96.576122.34151z" style="line-height:normal;font-variant-ligatures:normal;font-variant-position:normal;font-variant-caps:normal;font-variant-numeric:normal;font-variant-alternates:normal;font-feature-settings:normal;text-indent:0;text-align:start;text-decoration-line:none;text-decoration-style:solid;text-decoration-color:#000;text-transform:none;text-orientation:mixed;white-space:normal;shape-padding:0;isolation:auto;mix-blend-mode:normal;solid-color:#000;solid-opacity:1" fill="#333" stroke="#333" stroke-linecap="round" stroke-linejoin="round" stroke-width="9.41981792" color="#000" font-family="sans-serif" font-weight="400" overflow="visible" paint-order="stroke fill markers"/>
  <path fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="2.06500006" d="M122.73202 199.99714h25.46928z"/>
  <path fill="#666" d="M122.73203 176.92772h25.469278v22.540266H122.73203z" opacity=".98999999" paint-order="stroke fill markers"/>
  <g opacity=".472">
    <path fill="url(#c)" d="M122.73203 176.92772h25.469278v22.540266H122.73203z" opacity=".98999999" paint-order="stroke fill markers"/>
  </g>
  <path fill="#f9f9f9" stroke="#666" stroke-linecap="round" stroke-linejoin="round" stroke-width="7.06237888" d="M7.9654365 8.2232809h255.00246v163.86629H7.9654365z" opacity=".98999999" paint-order="stroke fill markers"/>
  <path fill="none" stroke="#333" stroke-linecap="round" stroke-linejoin="round" stroke-width="7.31291819" d="M4.5159678 4.773207h261.9014v171.07066h-261.9014z" opacity=".98999999" paint-order="stroke fill markers"/>
</svg>
EOF
}
