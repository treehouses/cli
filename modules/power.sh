function power {
    checkrpi
    checkargn $# 2
    mode="$1"
    case "$mode" in
        ondemand)
            checkroot
            echo "ondemand"
            changegovernor "ondemand"
            ;;
        conservative)
            checkroot 
            echo "conservative"
            changegovernor "conservative"
            ;;
        userspace)
            checkroot
            echo "userspace"
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
        #echo $RESULT > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    else
        echo "Did not recognize mode"
    fi
}
