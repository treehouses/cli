function resolution() {
  group=$1
  mode=$2
  available=0
  checkargn $# 2
  config=/boot/config.txt
  if [ $group == "CEA" ]; then
    names=$(tvservice -m CEA)
    saveifs=$IFS
    IFS=$'\n'
    names=($names)
    IFS=$saveifs
    for i in "${names[@]}"; do
      mode_available=$(echo $i | cut -d':' -f 1 | awk '{print $NF}')
      if [ "$mode" == "$mode_available" ]; then
        echo "mode available"
        available=1
      fi
    done
    if [ $available == 1 ]; then
      set_config_var hdmi_group $group $config
      set_config_var hdmi_mode $mode $config
      echo "Screen resolution is set to"
      echo "reboot needed to see the changes"
    else
      echo "mode is not available  Possible modes are:"
      tvservice -m CEA
    fi
  elif [ $group == "DMT" ]; then
    names=$(tvservice -m DMT)
    saveifs=$IFS
    IFS=$'\n'
    names=($names)
    IFS=$saveifs  
    for i in "${names[@]}"; do
      mode_available=$(echo $i | cut -d':' -f 1 | awk '{print $NF}')
      if [ "$mode" == "$mode_available" ]; then
        echo "mode available"
        available=1
      fi
    done
     if [ $available == 1 ]; then
      set_config_var hdmi_group $group $config
      set_config_var hdmi_mode $mode $config
      echo "Screen resolution is set to $group $mode"
      echo "reboot needed to see the changes"
     else
      echo "mode is not available  Possible modes are:"
      tvservice -m DMT
     fi
  else
    echo "hdmi group should be eithr CEA or DMT"
  fi
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
