#!/bin/bash

function vnc {
  status=$1
  bootoptionstatus=$(systemctl is-enabled graphical.target)
  vncservicestatus=$(service vncserver-x11-serviced status | grep -q 'running')
  xservicestatus=$(service lightdm status | grep -q 'running')
  websockifystatus=$(pgrep -cw websockify)
  ipaddress=$(/usr/lib/vnc/get_primary_ip4)
  
  # Get the status of each VNC related service for status-service
  if [ "$bootoptionstatus" = "static" ]; then
    isgraphical="Console"
    elif [ "$bootoptionstatus" = "indirect" ]; then
    isgraphical="Desktop"
  fi
    
  if [ ! "$vncservicestatus" ]; then
    isenabledvnc="running"
    elif [ "$vncservicestatus" ]; then
    isenabledvnc="not running"
  fi
      
  if [ ! "$xservicestatus" ]; then
    isenabledx="running"
    elif [ "$xservicestatus" ]; then
    isenabledx="not running"
  fi
  
  if [ "$websockifystatus" != 0 ]; then
    isenabledws="running"
    elif [ "$websockifystatus" = 0 ]; then
    isenabledws="not running"
  fi
  
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
    grep -qF 'hdmi_group=2' '/boot/config.txt' || echo 'hdmi_group=2' | tee -a '/boot/config.txt'
    grep -qF 'hdmi_mode=82' '/boot/config.txt' || echo 'hdmi_mode=82' | tee -a '/boot/config.txt'
    sed -i 's/#hdmi_force_hotplug=1/hdmi_force_hotplug=1/' /boot/config.txt
    sed -i '/Authentication=VncAuth/d' /root/.vnc/config.d/vncserver-x11
    sed -i '/Password=4428a3faa46efad1/d' /root/.vnc/config.d/vncserver-x11
    sed -i '/websockify -D --web=/usr/share/novnc/ 6080 localhost:5901/d' /etc/rc.local
    systemctl set-default graphical.target
    reboot_needed
    echo "Success: the vnc service has been started and enabled when the system boots."
    echo "You can then remotely access the system with a VNC client using the IP address: $ipaddress" 
    
# Does what "vnc on" does, plus changes the authentication scheme for noVNC
# and starts a websocket on port 6080 to tunnel the vnc connection
  elif [ "$status" = "html-on" ]; then
  
    # Checks if the required packages are installed
    if [ ! -d /usr/share/doc/websockify ] || [ ! -d /usr/share/doc/novnc ]; then
    echo "Error: noVNC and/or websockify are not installed."
      while true; do
        read -n 1 -p "Do you want to install the prerequisite packages for noVNC? (y/n)" answer
        case "$answer" in
          "y"* ) apt-get upgrade;
                  apt-get install websockify novnc -y;;
          "n"* ) echo "To install them manually, run:";
                  echo "apt-get install websockify novnc";
                  exit 1;;
          * ) echo "Please answer (y)es or (n)o.";;
        esac
      done
    fi
    
    # Similar to vnc on, starting services
    enable_service vncserver-x11-serviced.service
    start_service vncserver-x11-serviced.service
    grep -qF 'hdmi_group=2' '/boot/config.txt' || echo 'hdmi_group=2' | tee -a '/boot/config.txt'
    grep -qF 'hdmi_mode=82' '/boot/config.txt' || echo 'hdmi_mode=82' | tee -a '/boot/config.txt'
    sed -i 's/#hdmi_force_hotplug=1/hdmi_force_hotplug=1/' /boot/config.txt
    systemctl set-default graphical.target
    
    # Changing authentication scheme for noVNC
    # Password is "raspberry"
    grep -qF 'Authentication=VncAuth' '/root/.vnc/config.d/vncserver-x11' || echo 'Authentication=VncAuth' | tee -a '/root/.vnc/config.d/vncserver-x11'
    grep -qF 'Password=4428a3faa46efad1' '/root/.vnc/config.d/vncserver-x11' || echo 'Password=4428a3faa46efad1' | tee -a '/root/.vnc/config.d/vncserver-x11'
    
    # Starting the websocket daemon on startup
    sed -i 's/exit 0/websockify -D --web=/usr/share/novnc/ 6080 localhost:5901/' /etc/rc.local
    sed -i '$ a exit 0' /etc/rc.local
    reboot_needed
    echo "Success: the vnc html-enabled service has been started and enabled when the system boots."
    echo "You can then remotely access the system with a VNC client using the link:" 
    echo "$ipaddress:6080/vnc.html"
    echo "Password is raspberry"
 
# Prints the link to the system for access via HTML; Paste this to a browser
elif [ "$status" = "html-link" ]; then   
    if [ "$bootoptionstatus" = "indirect" ] && [ ! "$vncservicestatus" ] && [ ! "$xservicestatus" ]  && [ "$websockifystatus" != 0 ]; then
    echo "$ipaddress:6080/vnc.html"
    else
    echo "VNC and/or HTML capabilities are not enabled. Try running:"
    echo "$(basename "$0") vnc html-link"
    fi
    
# Stops the VNC server service, modifies the config.txt to no longer output screen data  if a screen is missing
# and sets the system to run the console interface on boot 
  elif [ "$status" = "off" ]; then
    disable_service vncserver-x11-serviced.service
    stop_service vncserver-x11-serviced.service    
    sed -i '/hdmi_group=2/d' /boot/config.txt
    sed -i '/hdmi_mode=82/d' /boot/config.txt 
    sed -i 's/hdmi_force_hotplug=1/#hdmi_force_hotplug=1/' /boot/config.txt
    sed -i '/Authentication=VncAuth/d' /root/.vnc/config.d/vncserver-x11
    sed -i '/Password=4428a3faa46efad1/d' /root/.vnc/config.d/vncserver-x11
    sed -i '/websockify -D --web=/usr/share/novnc/ 6080 localhost:5901/d' /etc/rc.local
    systemctl set-default multi-user.target
    reboot_needed
    echo "Success: the vnc service has been stopped and disabled when the system boots."
 
# Prints the status of the VNC server, along with advice to enable it or disable it accordingly
  elif [ "$status" = "status" ]; then
    if [ "$bootoptionstatus" = "static" ] && [ "$vncservicestatus" ] && [ "$xservicestatus" ] && [ "$websockifystatus" = 0 ]; then
      echo "VNC is disabled." 
      echo "To enable it, use $(basename "$0") vnc on"
    elif [ "$bootoptionstatus" = "indirect" ] && [ ! "$vncservicestatus" ] && [ ! "$xservicestatus" ]  && [ "$websockifystatus" = 0 ]; then
      echo "VNC is enabled without HTML capabilities."
      echo "You can now remotely access the system with a VNC client using the IP address: $ipaddress"  
      echo "To enable HTML and access your system from a browser, use $(basename "$0") vnc html-on"
      echo "To disable it, use $(basename "$0") vnc off"
    elif [ "$bootoptionstatus" = "indirect" ] && [ ! "$vncservicestatus" ] && [ ! "$xservicestatus" ]  && [ "$websockifystatus" != 0 ]; then
      echo "VNC is enabled with HTML capabilities."
      echo "You can now remotely access the system with an HTML browser using the link: $ipaddress:6080/vnc.html"
      echo "Password is raspberry"
      echo "To keep vnc enabled and accessable by a VNC viewer, but not HTML, use $(basename "$0") vnc on"
      echo "To disable vnc altogether, use $(basename "$0") vnc off"
    else
      echo "VNC server is not configured correctly. Please try $(basename "$0") vnc on to enable it, or $(basename "$0") vnc off to disable it."
      echo "Alternatively, you may try $(basename "$0") vnc status-service to verify the status of each specific required service."
    fi
    
 # Prints the status of the specific VNC related services, along with advice to enable it or disable it accordingly
  elif [ "$status" = "status-service" ]; then
      echo "The system boots into $isgraphical"
      echo "The VNC service is $isenabledvnc"
      echo "The X window service is $isenabledx"
      echo "The websockify service is $isenabledws"
      echo "In order to access your desktop via a VNC viewer, the system needs to boot into Desktop, and VNC and X window services need to be running"
      echo "To access it through html (a web browser), the websockify service needs to run along the aforementioned services."
      if [ "$bootoptionstatus" = "static" ] || [ "$vncservicestatus" ] || [ "$xservicestatus" ]; then
      echo "Your system is not configured correctly."
      echo "You may try $(basename "$0") vnc on, or attempt to enable any missing service manually"
    fi
    
  else
    echo "Error: only 'on', 'html-on' 'off', 'status' and 'status-service' options are supported";
  fi
}

# Prints the options for the "vnc" command
function vnc_help {
  echo ""
  echo "Usage: $(basename "$0") vnc <on|html-on|off|status|status-service>"
  echo ""
  echo "Enables or disables the VNC server service"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") vnc status"
  echo "      Prints the status of the VNC server (enabled or disabled)."
  echo ""
  echo "Example:"
  echo "  $(basename "$0") vnc status-service"
  echo "      Prints the configuration of each required component (boot option, vnc service, x service)."
  echo ""
  echo "  $(basename "$0") vnc on"
  echo "      The VNC service will be enabled. This will allow devices on your network to be able to connect to the raspberry pi using VNC viewer."
  echo "      This will disable html, if it is active."
  echo ""
  echo "  $(basename "$0") vnc html-on"
  echo "      The VNC service will be enabled, with html. This will allow devices on your network to be able to connect to the raspberry pi using an HTML browser."
  echo "      Password for the VNC server is raspberry"
  echo ""
  echo "  $(basename "$0") vnc off"
  echo "      VNC services will be disabled."
} 
