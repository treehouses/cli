
function resolution() {
  group=$1
  mode=$2
  checkargn $# 2
  config=/boot/config.txt
  if [ $group == "CEA" ]; then
    case $mode in
      "1")
        echo -e "Resolution set to 640x480 \n Aspect ratio 4:3 \n Refresh Rate 60Hz"
        ;;
      "2")
        echo -e "Resolution set to 720x480  \n Aspect ratio 4:3 \n Refresh Rate 60Hz"
        ;;
      "3")
        echo -e "Resolution set to 720x480  \n Aspect ratio 16:9  \n Refresh Rate 60Hz"
        ;;
      "4")
        echo -e "Resolution set to 1280x720 \n Aspect ratio 16:9  \n Refresh Rate 60Hz"
        ;;
      "17")
        echo -e "Resolution set to 720x576 \n Aspect ratio 4:3  \n Refresh Rate 60Hz"
        ;;
      "18")
        echo -e "Resolution set to 720x576 \n Aspect ratio 16:9   \n Refresh Rate 60Hz"
        ;;
      "19")
        echo -e "Resolution set to 1280x720 \n Aspect ratio 16:9   \n Refresh Rate 60Hz"
        ;;
      *)
        echo "invalid mode input"
        tvservice -m CEA
        exit
        ;;
    esac
  elif [ $group == "DMT" ]; then
    case $mode in
      "2")
        echo -e "Resolution set to 640x480 \n Aspect ratio 4:3 \n Refresh Rate 60Hz"
        ;;
      "4")
        echo -e "Resolution set to 640x480 \n Aspect ratio 4:3 \n Refresh Rate 60Hz"
        ;;
      "6")
        echo -e "Resolution set to 640x480  \n Aspect ratio 4:3 \n Refresh Rate 60Hz"
        ;;
      "8")
        echo -e "Resolution set to 800x600  \n Aspect ratio 16:9  \n Refresh Rate 60Hz"
        ;;
      "9")
        echo -e "Resolution set to 800x600 \n Aspect ratio 16:9  \n Refresh Rate 60Hz"
        ;;
      "11")
        echo -e "Resolution set to 800x600 \n Aspect ratio 4:3  \n Refresh Rate 60Hz"
        ;;
      "16")
        echo -e "Resolution set to 1024x768  \n Aspect ratio 16:9   \n Refresh Rate 60Hz"
        ;;
      "18")
       echo -e "Resolution set to 1024x768 \n Aspect ratio 16:9   \n Refresh Rate 60Hz"
        ;;
      "21")
       echo -e "Resolution set to 1152x864 \n Aspect ratio 16:9   \n Refresh Rate 60Hz"
       ;;
      "28")
       echo -e "Resolution set to 1280x800 \n Aspect ratio 16:9   \n Refresh Rate 60Hz"
        ;;
      "35")
        echo -e "Resolution set to 1280x1024 \n Aspect ratio 4:3  \n Refresh Rate 60Hz"
        ;;
      "46")
        echo -e "Resolution set to 1440x900 \n Aspect ratio 16:9   \n Refresh Rate 60Hz"
        ;;
      "47") 
      echo -e "Resolution set to 1440x900 \n Aspect ratio 16:9   \n Refresh Rate 60Hz"
        ;;
      "85")
        echo -e "Resolution set to 1280x720  \n Aspect ratio 16:9   \n Refresh Rate 60Hz"
        ;;
      *)
        echo "invalid mode input"
        tvservice -m DMT
        exit
        ;;
    esac
  else
    echo "hdmi group should be eithr CEA or DMT"
    exit 0
 fi
  set_config_var hdmi_group $group $config
  set_config_var hdmi_mode $mode $config
  echo "reboot needed to see the changes"
}

set_config_var() {
  lua - "$1" "$2" "$3" <<EOF > "$3.bak"
local key=assert(arg[1])
local value=assert(arg[2])
local fn=assert(arg[3])
local file=assert(io.open(fn))
local made_change=false
for line in file:lines() do
  if line:match("^#?%s*"..key.."=.*$") then
    line=key.."="..value
    made_change=true
  end
  print(line)
end
if not made_change then
  print(key.."="..value)
end
EOF
mv "$3.bak" "$3"
}

function resolution_help {
  echo
  echo "  Usage: $BASENAME resolution <hdmi_group> <hdmi_mode>"
  echo
  echo "  screen resolution set to the specified hdmi_group and hdmi_mode"
  echo
  echo "  Example:"
  echo "  $BASENAME resolution CEA 1"
  echo "  System will set the resolution to CEA 640X480"
  echo
  echo "  $BASENAME resolution DMT 9"
  echo "  System will set the resolution to DMT 800X600"
  echo
}
