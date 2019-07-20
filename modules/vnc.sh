#!/bin/bash

function vnc {
  status=$1
  bootoptionstatus=$(sudo systemctl is-enabled graphical.target)
  servicestatus=$(sudo service vncserver-x11-serviced status | grep -q 'running')
  ipaddress=$(hostname -I)
  
  # Checks whether we have the required package to run a VNC server
  # Should be there on a stock treehouses install
  if [ ! -d /usr/share/doc/realvnc-vnc-server ] ; then
    echo "Error: the vnc server is not installed, to install it run:"
    echo "apt-get install realvnc-vnc-server"
    exit 1;
  fi

# Starts the VNC server service, modifies the config.txt to output screen data even if a screen is missing
# and sets the system to run the desktop graphical interface on boot
  if [ "$status" = "on" ]; then
    enable_service vncserver-x11-serviced.service
    start_service vncserver-x11-serviced.service
    sudo sed -i '$ a hdmi_group=2' /boot/config.txt
    sudo sed -i '$ a hdmi_mode=82' /boot/config.txt
    sudo sed -i 's/#hdmi_force_hotplug=1/hdmi_force_hotplug=1/' /boot/config.txt
    sudo systemctl set-default graphical.target
    reboot_needed
    echo "Success: the vnc service has been started and enabled when the system boots"
    echo "You can then remotely access the system with a VNC client using the IP address(es): $ipaddress" 

# Stops the VNC server service, modifies the config.txt to no longer output screen data  if a screen is missing
# and sets the system to run the console interface on boot 
  elif [ "$status" = "off" ]; then
    disable_service vncserver-x11-serviced.service
    stop_service vncserver-x11-serviced.service    
    sudo sed -i '/hdmi_group=2/d' /boot/config.txt
    sudo sed -i '/hdmi_mode=82/d' /boot/config.txt
    sudo sed -i 's/hdmi_force_hotplug=1/#hdmi_force_hotplug=1/' /boot/config.txt
    sudo systemctl set-default multi-user.target
    reboot_needed
    echo "Success: the vnc service has been stopped and disabled when the system boots."
 
# Prints the status of the VNC server, along with advice to enable it or disable it accordingly
  elif [ "$status" = "" ]; then
    if [ "$bootoptionstatus" = "static" -a "$servicestatus" = true ]; then
      echo "VNC is disabled." 
      echo "To enable it, use $(basename "$0") vnc on"
    elif [ "$bootoptionstatus" = "indirect" -a "$servicestatus" = flase ]; then
      echo "VNC is enabled."
      echo "You can now remotely access the system with a VNC client using the IP address(es): $ipaddress" 
      echo "To disable it, use $(basename "$0") vnc off"
    else
      echo "VNC server is not configured correclty. Please try $(basename "$0") vnc on to enable it, or $(basename "$0") vnc off to disable it."
    fi
  else
    echo "Error: only 'on', 'off' options are supported";
  fi
}

# Prints the options for the "vnc" command
function vnc_help {
  echo ""
  echo "Usage: $(basename "$0") vnc <on|off>"
  echo ""
  echo "Enables or disables the VNC server service"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") vnc"
  echo "      Prints the status of the VNC server (enabled or disabled)."
  echo ""
  echo "  $(basename "$0") vnc on"
  echo "      The VNC service will be enabled. This will allow devices on your network to be able to connect to the raspberry pi using VNC viewer."
  echo ""
  echo "  $(basename "$0") vnc off"
  echo "      The VNC service will be disabled."
} 
