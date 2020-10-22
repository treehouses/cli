#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/transmission/downloads
  mkdir /srv/transmission/watch

  # create yml(s)
  cat << EOF > /srv/transmission/transmission.yml
version: "2.1"
services:
  transmission:
    image: linuxserver/transmission
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /srv/transmission:/root/.transmission
      - /srv/transmission/downloads:/downloads
      - /srv/transmission/watch:/watch
    ports:
      - 9091:9091
      - 51413:51413
      - 51413:51413/udp
    restart: unless-stopped
EOF


  # add autorun
  cat << EOF > /srv/transmission/autorun
transmission_autorun=true

if [ "$transmission_autorun" = true ]; then
  treehouses services transmission up
fi


EOF
}

# environment var
function uses_env {
  echo false
}

# add supported arm(s)
function supported_arms {
  echo "armv7l"
  echo "aarch64"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "9091"
}

# add size (in MB)
function get_size {
  echo "77"
}

# add description
function get_description {
  echo "Transmission is a BitTorrent client with many powerful features"
}

# add info
function get_info {
  echo "https://github.com/linuxserver/docker-transmission"
  echo
  echo "Transmission is a BitTorrent client with features including encryption, a web interface, peer exchange, magnet links, DHT, µTP, UPnP and NAT-PMP port forwarding, webseed support, watch directories, tracker editing, global and per-torrent speed limits, and more."
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg5186" viewBox="0 0 48 48">
  <defs/>
  <defs id="defs5188">
    <linearGradient id="linearGradient9795">
      <stop id="stop9797" offset="0" stop-color="#fff" stop-opacity="1"/>
      <stop id="stop9799" offset="1" stop-color="#fff" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="linearGradient9783">
      <stop id="stop9785" offset="0" stop-color="#000" stop-opacity="1"/>
      <stop id="stop9787" offset="1" stop-color="#000" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="linearGradient9775">
      <stop id="stop9777" offset="0" stop-color="#f9f9f9" stop-opacity="1"/>
      <stop id="stop9779" offset="1" stop-color="#eeeeec" stop-opacity=".62037037"/>
    </linearGradient>
    <linearGradient id="linearGradient5948">
      <stop id="stop5950" offset="0" stop-color="#787b76" stop-opacity="1"/>
      <stop id="stop5956" offset=".87125719" stop-color="#babcb9" stop-opacity="1"/>
      <stop id="stop5952" offset="1" stop-color="#787b76" stop-opacity="1"/>
    </linearGradient>
    <linearGradient id="linearGradient5908">
      <stop id="stop5910" offset="0" stop-color="#fff" stop-opacity="1"/>
      <stop id="stop5912" offset="1" stop-color="#fff" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="linearGradient5898">
      <stop id="stop5900" offset="0" stop-color="#c00" stop-opacity="1"/>
      <stop id="stop5906" offset=".36509839" stop-color="#ef0000" stop-opacity="1"/>
      <stop id="stop5902" offset="1" stop-color="#a00" stop-opacity="1"/>
    </linearGradient>
    <linearGradient id="linearGradient5871">
      <stop id="stop5873" offset="0" stop-color="#f0f2ef" stop-opacity="1"/>
      <stop id="stop5875" offset="1" stop-color="#cdd1c8" stop-opacity="1"/>
    </linearGradient>
    <linearGradient id="linearGradient5843">
      <stop id="stop5845" offset="0" stop-color="#888a85" stop-opacity="1"/>
      <stop id="stop5847" offset="1" stop-color="#2e3436" stop-opacity="1"/>
    </linearGradient>
    <linearGradient id="linearGradient5835">
      <stop id="stop5837" offset="0" stop-color="#555753" stop-opacity="1"/>
      <stop id="stop5839" offset="1" stop-color="#2e3436" stop-opacity="1"/>
    </linearGradient>
    <linearGradient id="linearGradient5823">
      <stop id="stop5825" offset="0" stop-color="#2e3436" stop-opacity="1"/>
      <stop id="stop5827" offset="1" stop-color="#2e3436" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="linearGradient5234">
      <stop id="stop5236" offset="0" stop-color="#babdb6" stop-opacity="1"/>
      <stop id="stop5242" offset=".13299191" stop-color="#eeeeec" stop-opacity="1"/>
      <stop id="stop5238" offset="1" stop-color="#babdb6" stop-opacity="1"/>
    </linearGradient>
    <linearGradient id="linearGradient5240" x1="23.738585" x2="23.738585" y1="4.156569" y2="19.46567" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient5234"/>
    <linearGradient id="linearGradient5829" x1="23.732271" x2="23.688078" y1="30.057167" y2="22.632544" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient5823"/>
    <linearGradient id="linearGradient5841" x1="23.9375" x2="23.9375" y1="30.616879" y2="36.357994" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient5835"/>
    <linearGradient id="linearGradient5849" x1="20.771132" x2="20.563131" y1="32.248005" y2="23.939499" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient5843"/>
    <linearGradient id="linearGradient5904" x1="14.8125" x2="14.8125" y1="5.6244211" y2="9" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient5898"/>
    <linearGradient id="linearGradient5914" x1="24.040522" x2="24.040522" y1="5.0690055" y2="10.0086" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient5908"/>
    <linearGradient id="linearGradient5928" x1="13.625" x2="14.125" y1="33.125" y2="24" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient5871"/>
    <linearGradient id="linearGradient5954" x1="10.1875" x2="10.1875" y1="20.25" y2="42.5" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient5948"/>
    <linearGradient id="linearGradient9781" x1="24.71875" x2="23.936657" y1="35.958694" y2="17.070877" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient9775"/>
    <linearGradient id="linearGradient9789" x1="18.3125" x2="18.3125" y1="20.743757" y2="21.814325" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient9783"/>
    <linearGradient id="linearGradient9801" x1="30.4375" x2="29.742416" y1="31.82852" y2="27.45352" gradientUnits="userSpaceOnUse" xlink:href="#linearGradient9795"/>
    <filter id="filter9771" width="1.0595316" height="1.2799102" x="-.02976581" y="-.13995509">
      <feGaussianBlur id="feGaussianBlur9773" stdDeviation=".5196773"/>
    </filter>
  </defs>
  <g id="layer1" stroke-opacity="1">
    <rect id="rect9761" width="41.901279" height="8.9116125" x="3" y="39" fill="#2e3436" fill-opacity="1" stroke="none" stroke-dasharray="none" stroke-dashoffset="0" stroke-linecap="round" stroke-linejoin="round" stroke-miterlimit="4" stroke-width="1" filter="url(#filter9771)" opacity=".28240741" rx="2.2980971" ry="2.2980971"/>
    <path id="path5232" fill="url(#linearGradient5954)" fill-opacity="1" fill-rule="evenodd" stroke="#555753" stroke-linecap="butt" stroke-linejoin="miter" stroke-width="1.00000012" d="M10 16.59375c-1.1803919-.044936-2.3597865.977972-2.46875 2.21875-.887958 7.287583-2.2042894 14.591027-2.875 21.875V43.75c.0337593 1.579492 1.0709291 2.642039 2.21875 2.84375H41.5c.979024-.024504 2.065009-.7037 2.03125-2v-3.9375l-3.125-21.21875c-.253819-1.301823-1.366716-2.684784-2.90625-2.84375H10z"/>
    <path id="path5230" fill="url(#linearGradient5928)" fill-opacity="1" fill-rule="evenodd" stroke="#555753" stroke-linecap="butt" stroke-linejoin="miter" stroke-width=".99999994" d="M10.601853 39.624614c-1.129613-.122471-1.9284669-.86366-1.9004235-2.223568l1.9004235-15.993313c.292078-1.068335.985096-1.922384 2.079056-1.919291h21.924592c1.086317-.03268 2.172633.720354 2.457068 1.616245l2.415866 16.132924c.057046 1.469103-.547423 2.319487-1.565342 2.285988l-27.31124.101015z"/>
    <path id="path5197" fill="url(#linearGradient5841)" fill-opacity="1" fill-rule="evenodd" stroke="url(#linearGradient5849)" stroke-linecap="butt" stroke-linejoin="miter" stroke-width="1" d="M20.46875 20.4375l-2.0625 12.03125H15.4375l8.03125 5.15625 8.96875-5.15625h-2.96875l-1.875-12.03125h-7.125z"/>
    <rect id="rect5224" width="31.113209" height="6.0609155" x="8.4847708" y="4.5135489" fill="url(#linearGradient5904)" fill-opacity="1" stroke="#930000" stroke-dasharray="none" stroke-dashoffset="0" stroke-linecap="round" stroke-linejoin="round" stroke-miterlimit="4" stroke-width="1.00000012" opacity="1" rx="5.0159144" ry="1.9854566"/>
    <rect id="rect5896" width="29.080278" height="3.9395947" x="9.5003824" y="5.5690055" fill="none" fill-opacity="1" stroke="url(#linearGradient5914)" stroke-dasharray="none" stroke-dashoffset="0" stroke-linecap="round" stroke-linejoin="round" stroke-miterlimit="4" stroke-width="1.00000012" opacity=".58333333" rx="1.8339339" ry="1.2783499"/>
    <path id="path5881" fill="none" fill-opacity="1" fill-rule="evenodd" stroke="url(#linearGradient9781)" stroke-linecap="butt" stroke-linejoin="miter" stroke-width="1.00000012" d="M10.592965 17.57221c-1.118813-.04202-2.2366781.914517-2.3399596 2.074792L5.4687498 39.722803c.0109114.125083.0310387.256896.0592395.379891v2.863797c.0319997 1.477012 1.0150604 2.441394 2.1030016 2.630018H40.479283c.927949-.022912 1.927661-.628821 1.895664-1.841012v-3.682025c.007282-.0285.0236-.05955.029619-.087667l-.029619-.204558v-.204556h-.02962l-2.902735-19.374463c-.240577-1.217358-1.295417-2.481368-2.754636-2.630018H10.592965z" opacity=".24537036"/>
    <path id="path5926" fill="url(#linearGradient9789)" fill-opacity="1" fill-rule="evenodd" stroke="none" stroke-linecap="butt" stroke-linejoin="miter" stroke-width="1" d="M10.210155 29.955767L12.048004 22l24.030146.05802 1.779791 8.986136-1.176777-9.074525c-.220971-1.001734-.751301-1.969631-1.723573-1.944543l-21.92031-.044195c-1.430395-.044194-1.711741.883884-2.037281 1.988738l-.789845 7.986136z" opacity=".20833333"/>
    <rect id="rect5226" width="7.0964494" height="25.970053" x="20.48369" y="3.6044116" fill="url(#linearGradient5240)" fill-opacity="1" stroke="#888a85" stroke-dasharray="none" stroke-dashoffset="0" stroke-linecap="round" stroke-linejoin="round" stroke-miterlimit="4" stroke-width="1" opacity="1" rx="1.0763195" ry="1.0763192"/>
    <rect id="rect5244" width="8.1317272" height="8.0433397" x="19.975765" y="22.013826" fill="url(#linearGradient5829)" fill-opacity="1" stroke="none" stroke-dasharray="none" stroke-dashoffset="0" stroke-linecap="round" stroke-linejoin="round" stroke-miterlimit="4" stroke-width="1" opacity="1" rx="1.0763195" ry="1.0763192"/>
    <path id="path5879" fill="none" fill-rule="evenodd" stroke="#fff" stroke-linecap="round" stroke-linejoin="miter" stroke-width="1" d="M11.423372 41.486321h28.110439" opacity=".43518521"/>
    <rect id="rect5892" width="5.151906" height="23.93712" x="21.428234" y="4.6321397" fill="none" fill-opacity="1" stroke="#fff" stroke-dasharray="none" stroke-dashoffset="0" stroke-linecap="round" stroke-linejoin="round" stroke-miterlimit="4" stroke-width="1" opacity=".22685185" rx="1.0763195" ry="1.0763192"/>
    <g id="g5972" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="miter" opacity=".62037037">
      <path id="path5831" stroke="#888a85" stroke-width="1" d="M20.4375 30.5H27.5" opacity="1"/>
      <path id="path5833" stroke="#888a85" stroke-width="1" d="M19.960998 32.5h8.015506" opacity=".68055556"/>
      <path id="path5958" stroke="#5d5d5c" stroke-width="1" d="M20.273498 31.5h7.453006" opacity="1"/>
      <path id="path5960" stroke="#5d5d5c" stroke-width=".99999994" d="M19.869986 33.488738h8.271291" opacity=".68055556"/>
    </g>
    <path id="path9791" fill="none" fill-rule="evenodd" stroke="#fff" stroke-linecap="round" stroke-linejoin="miter" stroke-width="1" d="M14.381412 31.513733h3.137786"/>
    <path id="path9803" fill="none" fill-rule="evenodd" stroke="#fff" stroke-linecap="round" stroke-linejoin="miter" stroke-width="1" d="M30.443912 31.451233h3.137786"/>
    <path id="path5119" fill="#fff" fill-opacity="1" stroke="none" stroke-dasharray="none" stroke-dashoffset="0" stroke-linecap="round" stroke-linejoin="round" stroke-miterlimit="4" stroke-width="1" d="M11.048544 42.188465a1.1932427 1.0827572 0 11-2.3864858 0 1.1932427 1.0827572 0 112.3864858 0z" opacity=".33500001" transform="matrix(.42163 0 0 .4766 5.3634688 21.39228)"/>
  </g>
</svg>
EOF
}
