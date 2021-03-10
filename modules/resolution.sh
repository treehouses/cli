function resolution() {
  mode=$2
  available=0
  checkargn $# 2
  config=/boot/config.txt
  if [ "$1" == "cea" ]; then
    group=1
  elif [ "$1" == "dmt" ]; then
    group=2
  fi
  if [ "$group" == 1 ]; then
    names=$(tvservice -m CEA)
    saveifs=$IFS
    IFS=$'\n'
    names=($names)
    IFS=$saveifs
    for i in "${names[@]}"; do
      mode_available=$(echo $i | cut -d':' -f 1 | awk '{print $NF}')
      if [ "$mode" == "$mode_available" ]; then
        set_resolution=$(echo ${i} | tr -d '[:space:]')
        available=1
      fi
    done
    if [ $available == 1 ]; then
      set_config_var hdmi_force_hotplug 1 $config
      set_config_var hdmi_group $group $config
      set_config_var hdmi_mode $mode $config
      echo "Screen resolution set to $set_resolution"
      reboot_needed
      echo "reboot needed to see the changes"
    else
      echo "mode is not available  Possible modes are:"
      tvservice -m CEA
    fi
  elif [ "$group" == 2 ]; then
    names=$(tvservice -m DMT)
    saveifs=$IFS
    IFS=$'\n'
    names=($names)
    IFS=$saveifs  
    for i in "${names[@]}"; do
      mode_available=$(echo $i | cut -d':' -f 1 | awk '{print $NF}')      
      if [ "$mode" == "$mode_available" ]; then
        set_resolution=$(echo ${i} | tr -d '[:space:]')
        available=1
      fi
    done
      if [ $available == 1 ]; then
      set_config_var hdmi_force_hotplug 1 $config
      set_config_var hdmi_group $group $config
      set_config_var hdmi_mode $mode $config
      echo "Screen resolution set to $set_resolution"
      reboot_needed
      echo "reboot needed to see the changes"
      else
      echo "mode is not available  Possible modes are:"
      tvservice -m DMT
     fi
  else
    echo "hdmi group should be either cea or dmt"
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
  echo "Usage: $BASENAME resolution <hdmi_group> <hdmi_mode>"
  echo
  echo "screen resolution set to the specified hdmi_group and hdmi_mode"
  echo
  echo "Example:"
  echo "  $BASENAME resolution cea 4"
  echo "  System will set the resolution to CEA 1280x720"
  echo
  echo "  $BASENAME resolution dmt 4"
  echo "  System will set the resolution to DMT 640x480"
  echo
}
