function power {
    checkrpi
    checkargn $# 2
    mode="$1"
    case "$mode" in
        threshold)
            checkroot
            echo "changing threshold"
            changethreshhold
            ;;
        ondemand)
            checkroot
            echo "power setting changed to ondemand"
            changegovernor "ondemand"
            ;;
        conservative)
            checkroot 
            echo "power setting changed to conservative"
            changegovernor "conservative"
            ;;
        userspace)
            checkroot
            echo "power setting changed to userspace"
            changegovernor "userspace"
            ;;
        powersave)
            checkroot
            echo "all cores set at minimum frequency"
            changegovernor "powersave"
            ;;
        performance)
            checkroot
            echo "all cores set at maximum frequency"
            changegovernor "performance"
            ;; 
        "")
            echo "Error: please choose one of the 5 modes"
            ;;
        *)
            echo -e "Error: power '$mode' does not exist"
            exit 1
            ;;
    esac     
}

function changegovernor {
    sudo echo $1 | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor > /dev/null 2>&1
    RESULT=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    if [ "$RESULT" == "$1" ]; then
        local_fs='$local_fs'
        network='$network'
        named='$named'
        time='$time'
        syslog='$syslog'
        echo "Set governor to $RESULT"
        echo "CPU frequency is now $/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
    else
        echo "Did not recognize mode"
    fi
}

# TODO: Let user change their CPU threshold
# cat /sys/devices/system/cpu/cpufreq/ondemand/up_threshold