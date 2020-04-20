#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/mariadb

  # create yml(s)
  {
    echo "version: '3'"
    echo "services:"
    echo "  mariadb:"
    echo "    image: jsurf/rpi-mariadb"
    echo "    ports:"
    echo "      - 3306:3306"
    echo "    environment:"
    echo "      - MYSQL_ROOT_PASSWORD=\${MYSQL_ROOT_PASSWORD_VAR}"
  } > /srv/mariadb/mariadb.yml

  # create .env with default values
  {
    echo "MYSQL_ROOT_PASSWORD_VAR=my-secret-pw"
  } > /srv/mariadb/.env

  # add autorun
  {
    echo "mariadb_autorun=true"
    echo
    echo "if [ \"\$mariadb_autorun\" = true ]; then"
    echo "  docker-compose -f /srv/mariadb/mariadb.yml -p mariadb up -d"
    echo "fi"
    echo
    echo
  } > /srv/mariadb/autorun
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
  echo "3306"
}

# add size (in MB)
function get_size {
  echo "275"
}

# add info
function get_info {
  echo "https://mariadb.org/"
  echo
  echo "MariaDB is a community-developed fork of the MySQL relational database management system"
  echo "Connect to database with 'mysql -h\"127.0.0.1\" -P\"3306\" -uroot -p\"my-secret-pw\"'"
}

# add svg icon
function get_icon {
  cat <<EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns:i="http://ns.adobe.com/AdobeIllustrator/10.0/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cc="http://creativecommons.org/ns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape" version="1.0" id="Layer_1" x="0px" y="0px" viewBox="0 0 482.13 168.95" style="enable-background:new 0 0 482.13 168.95;" xml:space="preserve" sodipodi:docname="mariadb_org_rgb_h.svg" inkscape:version="0.92.4 5da689c313, 2019-01-14">
  <metadata id="metadata61">
    <rdf:RDF>
      <cc:Work rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <defs id="defs59" />
  <sodipodi:namedview pagecolor="#ffffff" bordercolor="#666666" borderopacity="1" objecttolerance="10" gridtolerance="10" guidetolerance="10" inkscape:pageopacity="0" inkscape:pageshadow="2" inkscape:window-width="3840" inkscape:window-height="2032" id="namedview57" showgrid="false" inkscape:zoom="4.538195" inkscape:cx="247.80682" inkscape:cy="87.705332" inkscape:window-x="0" inkscape:window-y="54" inkscape:window-maximized="1" inkscape:current-layer="Layer_1" />
  <style type="text/css" id="style2">
.st0{fill:#FFFFFF;}
.st1{fill-rule:evenodd;clip-rule:evenodd;fill:#1F305F;}
.st2{fill:#C0765A;}
.st3{fill:#1F305F;}
.st4{fill:#A0624D;}
</style>
  <switch id="switch54" style="opacity:1">
    <foreignObject requiredExtensions="http://ns.adobe.com/AdobeIllustrator/10.0/" x="0" y="0" width="1" height="1"></foreignObject>
    <g i:extraneous="self" id="g52" style="">
      <g id="g4445-4_3_" transform="translate(-1614.3646,-14.177857)" style="">
        <g id="g4447-8_3_" style="">
          <path id="path4449-4_3_" class="st1" d="M1812.22,38.13c-2.73,0.09-1.94,1.32-7.85,2.78c-5.97,1.47-13.19,0.57-19.61,3.27      c-16.8,7.04-19.52,34.26-39.53,44.79c-13.12,7.41-26.5,9.11-38.46,12.86c-9.6,3.85-15.57,6.4-22.61,12.47      c-5.46,4.71-6.79,9.28-12.5,15.19c-5.79,7.87-27.74,0.88-33.39,10.75c2.98,1.93,4.7,2.46,9.93,1.77      c-1.08,2.05-7.96,4.75-6.71,7.77c0,0,16.63,3.03,30.65-5.43c6.54-2.66,12.67-8.29,22.83-9.64c13.16-1.75,27.99,2.76,43.9,4.03      c-3.29,6.5-6.68,10.34-10.31,15.7c-1.12,1.21,0.96,2.28,4.82,1.55c6.94-1.72,11.97-3.58,16.96-7.03      c6.51-4.49,9.31-8.6,14.8-15.11c4.77,7.65,21.59,9.33,25.04,2.72c-6.42-2.72-7.79-16.87-5.59-22.98      c2.6-5.82,4.47-14.05,6.57-21.7c1.89-6.89,3.06-17.4,5.32-22.78c2.7-6.69,7.95-8.78,11.89-12.33c3.94-3.55,7.86-6.51,7.74-14.63      C1816.07,39.51,1814.71,38.05,1812.22,38.13L1812.22,38.13z" style="" />
          <path id="path4451-9_3_" class="st2" d="M1643.29,148.38c10.31,0.31,13.11,0.04,21.26-3.5c6.93-3.01,16.2-11.12,24.39-13.74      c12.02-3.86,24.91-3.28,37.7-1.77c4.28,0.51,8.58,1.22,11.65,0.89c4.79-2.94,5.02-10.92,7.99-11.56      c-0.81,15.44-7.43,25.32-14.05,34.28c13.95-2.46,23.27-11.17,28.91-21.95c1.71-3.27,4.55-8.62,5.85-12.3      c1.03,2.44-1.34,3.99-0.23,6.65c8.98-7.41,13.22-15.85,16.86-28.21c4.22-14.3,8.55-26.59,11.27-30.82      c2.65-4.13,6.78-6.68,10.55-9.32c4.28-3.01,8.11-6.14,8.77-11.87c-4.52-0.42-5.56-1.46-6.23-3.74      c-2.26,1.27-4.34,1.55-6.69,1.62c-2.04,0.06-4.28-0.03-7.02,0.25c-22.63,2.32-23.68,24.44-40.13,40.68      c-1.06,1.03-2.87,2.55-4.07,3.45c-5.08,3.79-10.52,5.87-16.25,8.06c-9.28,3.54-18.08,4.57-26.78,7.63      c-6.39,2.24-12.33,4.81-17.58,8.4c-1.31,0.9-3.09,2.5-4.23,3.43c-3.08,2.52-5.1,5.31-7.06,8.19c-2.02,2.96-3.96,6.01-6.93,8.92      c-4.81,4.72-22.77,1.38-29.1,5.76c-0.7,0.49-1.27,1.07-1.65,1.77c3.45,1.57,5.76,0.61,9.73,1.04      C1650.71,144.41,1642,146.65,1643.29,148.38L1643.29,148.38z" style="" />
          <path id="path4457-3_3_" class="st1" d="M1786.73,52.65c3.2,2.78,9.92,0.55,8.72-4.98      C1790.47,47.25,1787.59,48.94,1786.73,52.65z" style="" />
          <path id="path4459-4_3_" class="st3" d="M1809.06,46.18c-0.85,1.79-2.48,4.09-2.48,8.64c-0.01,0.78-0.59,1.32-0.6,0.11      c0.04-4.45,1.22-6.37,2.47-8.89C1809.02,45.01,1809.37,45.43,1809.06,46.18z" style="" />
          <path id="path4461-6_3_" class="st3" d="M1808.2,45.51c-1.01,1.7-3.43,4.81-3.82,9.35c-0.07,0.78-0.71,1.26-0.61,0.06      c0.44-4.42,2.37-7.19,3.84-9.6C1808.27,44.34,1808.58,44.79,1808.2,45.51z" style="" />
          <path id="path4463-0_3_" class="st3" d="M1807.42,44.62c-1.15,1.61-4.87,5.35-5.65,9.83c-0.14,0.77-0.81,1.19-0.61,0.01      c0.81-4.37,4.02-7.81,5.68-10.08C1807.58,43.45,1807.86,43.93,1807.42,44.62z" style="" />
          <path id="path4465-8_3_" class="st3" d="M1806.72,43.62c-1.36,1.44-5.8,6.2-7.2,10.53c-0.25,0.74-0.97,1.07-0.61-0.08      c1.41-4.22,5.3-8.76,7.27-10.77C1807.05,42.49,1807.25,43.01,1806.72,43.62L1806.72,43.62z" style="" />
        </g>
      </g>
      <g id="g4483-2_1_" transform="translate(-84.332895,80)" style="">
        <g id="g4485-8_1_" transform="translate(1.2626907,0)" style="">
          <path id="path4487-2_1_" class="st3" d="M449.69-19.44v31.22h-3.94V6.43c-3.57,4.27-7.64,6.41-12.23,6.41      c-4.59,0-8.47-1.63-11.64-4.88c-3.14-3.29-4.7-7.19-4.7-11.7c0-4.55,1.59-8.43,4.76-11.64c3.17-3.25,6.98-4.88,11.41-4.88      c5.1,0,9.23,2.18,12.41,6.53v-5.7H449.69 M445.99-3.69c0-3.57-1.2-6.57-3.59-9c-2.39-2.47-5.33-3.7-8.82-3.7      c-3.45,0-6.37,1.27-8.76,3.82c-2.39,2.51-3.59,5.49-3.59,8.94s1.22,6.45,3.65,9c2.43,2.51,5.33,3.76,8.7,3.76      c3.41,0,6.33-1.22,8.76-3.65C444.78,3.06,445.99,0,445.99-3.69" style="" />
        </g>
        <g id="g4489-8_1_" transform="translate(0.50507628,0)" style="">
          <path id="path4491-4_1_" class="st3" d="M458.43,11.78v-42.21h8.76c6,0,10.39,0.45,13.17,1.35c2.82,0.86,5.25,2.25,7.29,4.17      c2.04,1.88,3.61,4.19,4.7,6.94c1.1,2.74,1.65,5.96,1.65,9.64c0,3.65-0.86,7.09-2.59,10.35c-1.69,3.21-4,5.64-6.94,7.29      c-2.9,1.65-7.09,2.47-12.58,2.47H458.43 M462.49,7.78h4.88c5.1,0,8.78-0.25,11.05-0.76c2.31-0.51,4.33-1.51,6.06-3      c1.72-1.53,3.04-3.37,3.94-5.53c0.9-2.16,1.35-4.62,1.35-7.41c0-2.78-0.53-5.35-1.59-7.7c-1.02-2.35-2.49-4.29-4.41-5.82      c-1.92-1.53-4.19-2.55-6.82-3.06c-2.59-0.55-6.41-0.82-11.46-0.82h-3L462.49,7.78" style="" />
        </g>
        <g id="g4493-2_1_" transform="translate(0.50507628,0)" style="">
          <path id="path4495-3_1_" class="st3" d="M406-28.14c0-0.9,0.31-1.69,0.94-2.35c0.67-0.67,1.45-1,2.35-1c0.94,0,1.72,0.33,2.35,1      c0.67,0.63,1,1.41,1,2.35c0,0.9-0.33,1.69-1,2.35c-0.63,0.63-1.41,0.94-2.35,0.94c-0.9,0-1.69-0.33-2.35-1      C406.31-26.52,406-27.28,406-28.14 M407.29-19.44h4.06v31.22h-4.06V-19.44" style="" />
        </g>
        <g id="g4497-1_1_" style="">
          <path id="path4499-4_1_" class="st3" d="M296.69,11.78l6-42.21h0.65L320.5,4.19l17.05-34.63h0.65l6.06,42.21h-4.17l-4.12-30.22      l-14.93,30.22h-1.06l-15.11-30.45l-4.12,30.45H296.69" style="" />
        </g>
        <g id="g4501-4_1_" transform="translate(-0.25253814,0)" style="">
          <path id="path4503-0_1_" class="st3" d="M381.11-19.44v31.22h-3.94V6.43c-3.57,4.27-7.64,6.41-12.23,6.41      c-4.59,0-8.47-1.63-11.64-4.88c-3.14-3.29-4.7-7.19-4.7-11.7c0-4.55,1.59-8.43,4.76-11.64c3.17-3.25,6.98-4.88,11.41-4.88      c5.1,0,9.23,2.18,12.41,6.53v-5.7H381.11 M377.41-3.69c0-3.57-1.2-6.57-3.59-9c-2.39-2.47-5.33-3.7-8.82-3.7      c-3.45,0-6.37,1.27-8.76,3.82c-2.39,2.51-3.59,5.49-3.59,8.94s1.21,6.45,3.65,9c2.43,2.51,5.33,3.76,8.7,3.76      c3.41,0,6.33-1.22,8.76-3.65C376.19,3.06,377.41,0,377.41-3.69" style="" />
        </g>
        <g id="g4505-7_1_" transform="translate(-1.0101526,0)" style="">
          <path id="path4507-8_1_" class="st3" d="M388.67-19.44h4.12v4.53c1.1-1.84,2.16-3.19,3.17-4.06c1.06-0.86,2.21-1.29,3.47-1.29      c1.29,0,2.59,0.35,3.88,1.06l-2.12,3.41c-0.59-0.35-1.2-0.53-1.82-0.53c-1.21,0-2.37,0.63-3.47,1.88      c-1.06,1.25-1.84,2.88-2.35,4.88c-0.51,1.96-0.76,5.55-0.76,10.76v10.58h-4.12L388.67-19.44" style="" />
        </g>
        <g id="g4509-8_1_" transform="translate(1.0101526,0)" style="">
          <path id="path4511-4_1_" class="st3" d="M498.3-30.44h8.35c4.43,0,7.78,0.9,10.05,2.7c2.31,1.76,3.47,4.31,3.47,7.64      c0,1.84-0.47,3.55-1.41,5.11c-0.9,1.53-2.23,2.76-4,3.7c2.9,0.94,5.1,2.35,6.58,4.23c1.53,1.88,2.29,4.12,2.29,6.7      c0,3.49-1.27,6.39-3.82,8.7c-2.55,2.27-5.84,3.41-9.88,3.41H498.3V-30.44 M502.47-26.32v13.52h2.41c3.68,0,6.43-0.59,8.23-1.76      c1.8-1.18,2.7-3.02,2.7-5.53c0-4.15-2.82-6.23-8.47-6.23H502.47 M502.47-8.56V7.66h5.23c3.02,0,5.23-0.29,6.64-0.88      c1.45-0.63,2.63-1.57,3.53-2.82c0.9-1.29,1.35-2.61,1.35-3.94s-0.25-2.51-0.76-3.53c-0.51-1.02-1.27-1.92-2.29-2.7      c-0.98-0.78-2.18-1.37-3.59-1.76c-1.37-0.39-3.96-0.59-7.76-0.59H502.47" style="" />
        </g>
      </g>
      <g id="g50" style="">
        <path class="st4" d="M226.41,112.51h-9.73v10.24h-4.2V98.58h15.36v3.39h-11.16v7.19h9.73V112.51z" id="path30" style="" />
        <path class="st4" d="M235.4,113.6c0-1.76,0.35-3.34,1.05-4.76c0.7-1.41,1.68-2.5,2.94-3.25c1.26-0.76,2.71-1.14,4.35-1.14     c2.42,0,4.39,0.78,5.9,2.34c1.51,1.56,2.33,3.63,2.45,6.21l0.02,0.95c0,1.77-0.34,3.35-1.02,4.75c-0.68,1.39-1.65,2.47-2.92,3.24     c-1.27,0.76-2.73,1.15-4.39,1.15c-2.53,0-4.56-0.84-6.08-2.53c-1.52-1.69-2.28-3.94-2.28-6.75V113.6z M239.43,113.95     c0,1.85,0.38,3.29,1.15,4.34c0.76,1.04,1.83,1.57,3.19,1.57c1.36,0,2.42-0.53,3.18-1.59c0.76-1.06,1.14-2.62,1.14-4.67     c0-1.82-0.39-3.25-1.17-4.32c-0.78-1.06-1.84-1.59-3.18-1.59c-1.32,0-2.36,0.52-3.14,1.57     C239.82,110.31,239.43,111.87,239.43,113.95z" id="path32" style="" />
        <path class="st4" d="M272.12,120.99c-1.18,1.39-2.87,2.09-5.05,2.09c-1.95,0-3.42-0.57-4.42-1.71c-1-1.14-1.5-2.79-1.5-4.95     v-11.64h4.03v11.59c0,2.28,0.95,3.42,2.84,3.42c1.96,0,3.28-0.7,3.97-2.11v-12.9h4.03v17.96h-3.8L272.12,120.99z" id="path34" style="" />
        <path class="st4" d="M291.61,104.79l0.12,2.08c1.33-1.6,3.07-2.41,5.23-2.41c3.74,0,5.64,2.14,5.71,6.42v11.87h-4.03v-11.64     c0-1.14-0.25-1.98-0.74-2.53c-0.49-0.55-1.3-0.82-2.42-0.82c-1.63,0-2.84,0.74-3.64,2.21v12.78h-4.03v-17.96H291.61z" id="path36" style="" />
        <path class="st4" d="M311.75,113.63c0-2.77,0.64-4.99,1.93-6.67c1.28-1.68,3-2.52,5.16-2.52c1.9,0,3.44,0.66,4.61,1.99v-9.2h4.04     v25.5h-3.65l-0.2-1.86c-1.21,1.46-2.82,2.19-4.83,2.19c-2.1,0-3.8-0.85-5.1-2.54C312.4,118.85,311.75,116.55,311.75,113.63z      M315.79,113.98c0,1.83,0.35,3.25,1.05,4.28c0.7,1.02,1.7,1.54,3,1.54c1.65,0,2.86-0.74,3.62-2.21v-7.67     c-0.74-1.44-1.94-2.16-3.59-2.16c-1.31,0-2.31,0.52-3.02,1.55C316.14,110.34,315.79,111.9,315.79,113.98z" id="path38" style="" />
        <path class="st4" d="M349.16,122.75c-0.18-0.34-0.33-0.9-0.46-1.68c-1.28,1.34-2.86,2.01-4.71,2.01c-1.8,0-3.28-0.51-4.42-1.54     c-1.14-1.03-1.71-2.3-1.71-3.82c0-1.92,0.71-3.38,2.13-4.41c1.42-1.02,3.46-1.54,6.1-1.54h2.47v-1.18c0-0.93-0.26-1.67-0.78-2.23     c-0.52-0.56-1.31-0.84-2.37-0.84c-0.92,0-1.67,0.23-2.26,0.69c-0.59,0.46-0.88,1.04-0.88,1.75h-4.03c0-0.99,0.33-1.91,0.98-2.76     c0.65-0.86,1.54-1.53,2.66-2.02c1.12-0.49,2.38-0.73,3.76-0.73c2.1,0,3.78,0.53,5.03,1.59c1.25,1.06,1.89,2.54,1.93,4.46v8.1     c0,1.62,0.23,2.91,0.68,3.87v0.28H349.16z M344.73,119.84c0.8,0,1.55-0.19,2.25-0.58c0.7-0.39,1.23-0.91,1.58-1.56v-3.39h-2.17     c-1.49,0-2.62,0.26-3.37,0.78c-0.75,0.52-1.13,1.26-1.13,2.21c0,0.77,0.26,1.39,0.77,1.85     C343.18,119.61,343.87,119.84,344.73,119.84z" id="path40" style="" />
        <path class="st4" d="M369.61,100.42v4.37h3.17v2.99h-3.17v10.03c0,0.69,0.14,1.18,0.41,1.49c0.27,0.3,0.75,0.46,1.45,0.46     c0.46,0,0.94-0.06,1.41-0.17v3.12c-0.92,0.25-1.8,0.38-2.66,0.38c-3.1,0-4.65-1.71-4.65-5.13v-10.18h-2.96v-2.99h2.96v-4.37     H369.61z" id="path42" style="" />
        <path class="st4" d="M384.6,100.12c0-0.62,0.2-1.13,0.59-1.54c0.39-0.41,0.95-0.61,1.69-0.61c0.73,0,1.29,0.21,1.69,0.61     c0.4,0.41,0.6,0.92,0.6,1.54c0,0.61-0.2,1.12-0.6,1.52c-0.4,0.4-0.96,0.61-1.69,0.61c-0.73,0-1.29-0.2-1.69-0.61     C384.8,101.24,384.6,100.73,384.6,100.12z M388.89,122.75h-4.03v-17.96h4.03V122.75z" id="path44" style="" />
        <path class="st4" d="M399.25,113.6c0-1.76,0.35-3.34,1.05-4.76c0.7-1.41,1.68-2.5,2.94-3.25c1.26-0.76,2.71-1.14,4.35-1.14     c2.42,0,4.39,0.78,5.9,2.34c1.51,1.56,2.33,3.63,2.45,6.21l0.02,0.95c0,1.77-0.34,3.35-1.02,4.75c-0.68,1.39-1.66,2.47-2.92,3.24     c-1.27,0.76-2.73,1.15-4.39,1.15c-2.53,0-4.56-0.84-6.08-2.53c-1.52-1.69-2.28-3.94-2.28-6.75V113.6z M403.29,113.95     c0,1.85,0.38,3.29,1.15,4.34c0.76,1.04,1.83,1.57,3.19,1.57c1.36,0,2.42-0.53,3.18-1.59c0.76-1.06,1.14-2.62,1.14-4.67     c0-1.82-0.39-3.25-1.17-4.32c-0.78-1.06-1.84-1.59-3.18-1.59c-1.32,0-2.36,0.52-3.14,1.57     C403.68,110.31,403.29,111.87,403.29,113.95z" id="path46" style="" />
        <path class="st4" d="M428.84,104.79l0.12,2.08c1.33-1.6,3.07-2.41,5.23-2.41c3.74,0,5.64,2.14,5.71,6.42v11.87h-4.03v-11.64     c0-1.14-0.25-1.98-0.74-2.53c-0.49-0.55-1.3-0.82-2.42-0.82c-1.63,0-2.84,0.74-3.64,2.21v12.78h-4.03v-17.96H428.84z" id="path48" style="" />
      </g>
    </g>
  </switch>
</svg>
EOF
}
