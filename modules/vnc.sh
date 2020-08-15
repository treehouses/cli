function vnc {
  local option bootoptionstatus vncservicestatus xservicestatus ipaddress isgraphical
  checkroot
  checkargn $# 2
  option=$1
  auth=$2
  bootoptionstatus=$(systemctl is-enabled graphical.target)
  vncservicestatus=$(systemctl is-active vncserver-x11-serviced)
  xservicestatus=$(systemctl is-active lightdm)
  ipaddress=$(/usr/lib/vnc/get_primary_ip4)

  # Get the status of each VNC related service for status-service
  if [ "$bootoptionstatus" = "static" ]; then
    isgraphical="Console"
  elif [ "$bootoptionstatus" = "indirect" ]; then
    isgraphical="Desktop"
  fi

  # Checks whether we have the required package to run a VNC server
  if [ ! -d /usr/share/doc/realvnc-vnc-server ] ; then
    echo "Error: the vnc server is not installed, to install it run:"
    echo "apt-get install realvnc-vnc-server"
    exit 1;
  fi

case "$option" in
  "")
    if [ "$bootoptionstatus" = "static" ] && [ "$vncservicestatus" = "inactive" ] && [ "$xservicestatus" = "inactive" ]; then
      echo "VNC is disabled."
      echo "To enable it, use $BASENAME vnc on"
    elif [ "$bootoptionstatus" = "indirect" ] && [ "$vncservicestatus" = "active" ] && [ "$xservicestatus" = "active" ]; then
      echo "You can now remotely access the system with a VNC client using the IP address: $ipaddress"
      echo "To disable it, use $BASENAME vnc off"
    elif [ "$bootoptionstatus" = "indirect" ] && [ "$vncservicestatus" = "active" ] && [ "$xservicestatus" = "failed" ]; then
      echo "Please reboot your system."
    elif [ "$bootoptionstatus" = "static" ] && [ "$vncservicestatus" = "inactive" ] && [ "$xservicestatus" = "active" ]; then
      echo "Please reboot your system."
    else
      echo "VNC server is not configured correctly. Please try $BASENAME vnc on to enable it, or $BASENAME vnc off to disable it."
      echo "Alternatively, you may try $BASENAME vnc status-service to verify the status of each specific required service."
    fi
    ;;
  "on")
    grep -qF 'hdmi_group=2' '/boot/config.txt' || echo 'hdmi_group=2' | tee -a '/boot/config.txt'
    grep -qF 'hdmi_mode=82' '/boot/config.txt' || echo 'hdmi_mode=82' | tee -a '/boot/config.txt'
    sed -i 's/#hdmi_force_hotplug=1/hdmi_force_hotplug=1/' /boot/config.txt
    enable_service vncserver-x11-serviced.service
    start_service vncserver-x11-serviced.service
    systemctl set-default graphical.target
    reboot_needed
    echo "Success: the vnc service has been started and enabled when the system boots."
    echo "Please reboot the system for changes to take effect."
    echo "You can then remotely access the system with a VNC client using the IP address: $ipaddress"
    ;;
  "off")
    sed -i '/hdmi_group=2/d' /boot/config.txt
    sed -i '/hdmi_mode=82/d' /boot/config.txt
    sed -i 's/hdmi_force_hotplug=1/#hdmi_force_hotplug=1/' /boot/config.txt
    stop_service vncserver-x11-serviced.service
    disable_service vncserver-x11-serviced.service
    systemctl set-default multi-user.target
    reboot_needed
    echo "Success: the vnc service has been stopped and disabled when the system boots."
    echo "Please reboot the system for changes to take effect."
    ;;
  "info")
    echo "The system boots into $isgraphical"
    echo "The VNC service is $vncservicestatus"
    echo "The X window service is $xservicestatus"
    echo "In order to access your desktop via a VNC viewer, the system needs to boot into Desktop, and VNC and X window services need to be running"
    if [ "$bootoptionstatus" = "indirect" ] && [ "$vncservicestatus" = "active" ] && [ "$xservicestatus" = "failed" ]; then
      echo "Please reboot your system."
    fi
    if [ "$bootoptionstatus" = "static" ] && [ "$vncservicestatus" = "inactive" ] && [ "$xservicestatus" = "active" ]; then
      echo "Please reboot your system."
    fi
    ;;
  "auth")
    case $auth in
        "system")
            echo "Changing VNC server authentication to system authentication way..."
            echo "Writing 'Authentication=SystemAuth' to config file"
            if [[ -f /root/.vnc/config.d/vncserver-x11 ]]
            then
                if grep -Fxq "Authentication" /root/.vnc/config.d/vncserver-x11
                then
                    sed -i 's/VncAuth/SystemAuth/' /root/.vnc/config.d/vncserver-x11
                else
                    echo "Authentication=SystemAuth" >> /root/.vnc/config.d/vncserver-x11
                fi
            else
                mkdir -p /root/.vnc/config.d
                echo "Authentication=SystemAuth" >> /root/.vnc/config.d/vncserver-x11
            fi
            treehouses vnc off > /dev/null 2>&1
            treehouses vnc on  > /dev/null 2>&1
            echo "Please reboot the system for changes to take effect."
        ;;
        "vncpasswd")
            echo "Changing VNC server authentication to VNC password authentication way..."
            echo "Writing 'Authentication=VncAuth' to config file"
            if [[ -f /root/.vnc/config.d/vncserver-x11 ]]
            then
                if grep -Fxq "Authentication" /root/.vnc/config.d/vncserver-x11
                then
                    sed -i 's/SystemAuth/VncAuth/' /root/.vnc/config.d/vncserver-x11
                    echo "Please reboot the system for changes to take effect."
                else
                    echo "Authentication=VncAuth" >> /root/.vnc/config.d/vncserver-x11
                fi
                treehouses vnc off > /dev/null 2>&1
                treehouses vnc on  > /dev/null 2>&1
            else
                echo "Please create a password first, run 'treehouses vnc passwd'."
            fi
        ;;
        *)
            echo "Error: only 'system', 'vncpasswd' options are supported"
        ;;
    esac
    ;;
  "passwd")
    echo "Creating password of VNC service mode for VNC password authentication..."
    vncpasswd -service
    ;;
 *)
    echo "Error: only 'on', 'off', 'info', 'auth', 'passwd' options are supported";
    exit 1;
    ;;
  esac
}

# Prints the options for the "vnc" command
function vnc_help {
  echo
  echo "Usage: $BASENAME vnc <on|off|info>"
  echo
  echo "Example:"
  echo "  $BASENAME vnc"
  echo "      Prints the status of the VNC server (enabled or disabled)."
  echo
  echo "  $BASENAME vnc on"
  echo "      The VNC service will be enabled. This will allow devices on your network to be able to connect to the raspberry pi using VNC viewer."
  echo "      This will disable html, if it is active."
  echo
  echo "  $BASENAME vnc off"
  echo "      VNC services will be disabled."
  echo
  echo "  $BASENAME vnc info"
  echo "      Prints a detailed configuration of each required component (boot option, vnc service, x service)."
  echo
  echo "  $BASENAME vnc auth <system|vncpasswd>"
  echo "      Change the VNC server authentication way (system default or vnc password)."
  echo
  echo "  $BASENAME vnc passwd"
  echo "      Create password of VNC service mode for VNC password authentication."
  echo
}
