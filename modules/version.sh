function version {
  local result contribs final
  checkargn $# 1
  if [ "$1" = "contributors" ]; then
    checkroot
    contribs=$(curl -s "https://api.github.com/repos/treehouses/cli/contributors" | jq '.[].login')
    contribs+="\n$(curl -s "https://api.github.com/repos/treehouses/remote/contributors" | jq '.[].login')"
    contribs+="\n$(curl -s "https://api.github.com/repos/treehouses/builder/contributors" | jq '.[].login')"
    contribs+="\n$(curl -s "https://api.github.com/repos/treehouses/control/contributors" | jq '.[].login')"
    contribs=$(echo -e "$contribs" | sort)
    result=""
    read -r -d '' result <<'EOF'

   ______________________________________________________________________
  |:..                                                      ``:::%%%%%%HH|
  |%%%:::::..                    I n t r o                     `:::::%%%%|
  |HH%%%%%:::::....._______________________________________________::::::|


.    .        .      .             . .     .        .          .          .
         .                 .                    .                .
  .               A long time ago in a repo far, far away...   .
     .               .           .               .        .             .
     .      .            .                 .                                .
 .      .         .         .   . :::::+::::...      .          .         .
     .         .      .    ..::.:::+++++:::+++++:+::.    .     .
                        .:.  ..:+:..+|||+..::|+|+||++|:.             .     .
            .   .    :::....:::::::::++||||O||O#OO|OOO|+|:.    .
.      .      .    .:..:..::+||OO#|#|OOO+|O||####OO###O+:+|+               .
                 .:...:+||O####O##||+|OO|||O#####O#O||OO|++||:     .    .
  .             ..::||+++|+++++|+::|+++++O#O|OO|||+++..:OOOOO|+  .         .
     .   .     +++||++:.:++:..+#|. ::::++|+++||++O##O+:.++|||#O+    .
.           . ++++++++...:+:+:.:+: ::..+|OO++O|########|++++||##+            .
  .       .  :::+++|O+||+::++++:::+:::+++::+|+O###########OO|:+OO       .  .
     .       +:+++|OO+|||O:+:::::.. .||O#OOO||O||#@###@######:+|O|  .
 .          ::+:++|+|O+|||++|++|:::+O#######O######O@############O
          . ++++: .+OO###O++++++|OO++|O#@@@####@##################+         .
      .     ::::::::::::::::::::++|O+..+#|O@@@@#@###O|O#O##@#OO####     .
 .        . :. .:.:. .:.:.: +.::::::::  . +#:#@:#@@@#O||O#O@:###:#| .      .
                           `. .:.:.:.:. . :.:.:%::%%%:::::%::::%:::
.      .                                      `.:.:.:.:   :.:.:.:.  .   .
           .                                                                .
      .
.          .                                                       .   .
                                                                             .
    .        .                                                           .
    .     .                                                           .      .
  .     .                                                        .
              .     @treehouses/cli is a command-line       .        .     .
                 interface for Raspberry Pi that is used      .  .
     .       .  to manage various services and functions.             .
.        .   Including vnc,ssh, tor, vpn, networking,starting                   .
   .      tons of services, bluetooth, led lights, and much more!   .      .
         @treehouses/remote is An Android app that communicates with 
    . headless RPi mobile server running treehouses image via Bluetooth. .   .
 . @treehouses/builder is based on Raspbian and allows the user to develop      .  .
.  .  and tailor their own custom Raspberry Pi images. The script will modify   .
      the latest Raspbian image by installing packages, purging packages and              .
      . executing custom commands, and then finally creates a bootable    .    .
.            .img file that can be burned to the microSD card.     .
    . @treehouses/control is A Python script running on a Raspberry Pi to  .
     receive commands (SSID & password) from / send executed results to an                                     .
  .                      Android Device over bluetooth              .
  zzzzzz zz zzzzzzzzz zzzzzz,  zzzzzzz zzzzzzz, zzzz zzzzzz, zzzzzzz zzzzz-  .
 zzzz, zzzzzzzz zzzzzzzz, zzz zzzzzzzz zzzz.              .         .
.        .          .    .    .            .            .                   .
               .               ..       .       .   .             .
 .      .     T h i s   i s   t h e   g a l a x y   o f   . . .             .
                     .              .       .                    .      .
.        .               .       .     .            .
   .           .        .                     .        .            .
             .               .    .          .              .   .         .
     _                     _                                       _            
    | |_  _ __  ___   ___ | |__    ___   _   _  ___   ___  ___    (_)  ___      
    | __|| '__|/ _ \ / _ \| '_ \  / _ \ | | | |/ __| / _ \/ __|   | | / _ \     
    | |_ | |  |  __/|  __/| | | || (_) || |_| |\__ \|  __/\__ \ _ | || (_) |    
     \__||_|   \___| \___||_| |_| \___/  \__,_||___/ \___||___/(_)|_| \___/     
   .           .        .                     .        .            .
.        .          .    .    .            .            .                   .
EOF
    final=$(echo -e "$result\n\n\n$contribs" | sed 's/"/      .       .       .       /g' | awk '!x[$0]++')
    while IFS= read -r line; do
      echo "$line"
      sleep 0.3
    done <<< "$final"
  elif [ "$1" = "remote" ]; then
    checkinternet
    wget -q https://github.com/treehouses/remote/releases
    line=$(grep -n label-latest releases)
    line=${line%%:*}
    line=$(sed -n $(( line + 12 ))p releases)
    rm releases
    line=${line:44}
    echo "Github: v${line%%\"*}"
    wget -q https://play.google.com/store/apps/details?id=io.treehouses.remote
    line=$(grep -n Current details\?id=io.treehouses.remote)
    line=${line%%:*}
    line=$(sed -n $(( line ))p details\?id=io.treehouses.remote)
    rm details\?id=io.treehouses.remote
    line=${line#*Current}
    line=${line:74}
    echo "GooglePlay: v${line%%<*}"
    wget -q https://f-droid.org/en/packages/io.treehouses.remote/
    line=$(sed -n 304p index.html)
    rm index.html
    line=${line#*Version }
    echo "F-droid: v${line%%<*}"
  elif [ "$1" = "" ]; then
    node -p "require('$SCRIPTFOLDER/package.json').version"
  else
    log_and_exit1 "Error: only 'contributors', 'remote',  or '' options supported"
  fi
}

function version_help () {
  echo
  echo "Usage: $BASENAME version"
  echo
  echo "Returns the version of $BASENAME command"
  echo
  echo "Example:"
  echo "  $BASENAME version"
  echo "      Prints the version of $BASENAME currently installed."
  echo
  echo "  $BASENAME version contributors"
  echo "      Prints the list of github contributors for @treehouses/cli @treehouses/remote @treehouses/builder @treehouses/control"
  echo
  echo "  $BASENAME version remote"
  echo "      Prints the latest versions of treehouses remote available on various platforms"
  echo
}
