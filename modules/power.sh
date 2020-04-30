function power {
    checkrpi
    checkargn $# 2
    mode="$1"
    case "$mode" in
        # threshold)
        #     checkroot
        #     echo "changing threshold"
        #     changethreshhold
        #     ;;
        ondemand)
            checkroot
            echo "Moves speed from min to max at about 90% load"
            changegovernor "ondemand"
            ;;
        conservative)
            checkroot 
            echo "Gradually switch frequencies at about 90% load"
            changegovernor "conservative"
            ;;
        userspace)
            checkroot
            echo "Use user specified frequency" # may need to create new functions to better use this setting
            changegovernor "userspace"
            ;;
        powersave)
            checkroot
            echo "All cores set at minimum frequency"
            changegovernor "powersave"
            ;;
        performance)
            checkroot
            echo "All cores set at maximum frequency"
            changegovernor "performance"
            ;; 
        freq)
            checkroot
            echo "CPU frequency is now $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)"
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
        echo "Scaling governor set to $RESULT"
    else
        echo "Failure, may need to use sudo"
    fi
}

# TODO: Let user change their CPU threshold
# cat /sys/devices/system/cpu/cpufreq/ondemand/up_threshold