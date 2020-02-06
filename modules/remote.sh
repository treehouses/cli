#!/bin/bash

function remote {
    option="$1"

    if [ "$option" = "status" ]; then
        results=""
        results+="$(internet) "
        results+="$(bluetooth mac) "
        results+="$(image) "
        results+="$(version) "
        results+="$(detectrpi)"

        echo ${results}
    elif [ "$option" = "upgrade" ]; then
        upgrade --check
    elif [ "$option" = "services" ]; then
        if [ "$2" = "available" ]; then
            results="Available: "
            results+="$(services available)"

            echo ${results}
        elif [ "$2" = "installed" ]; then
            results="Installed: "
            results+="$(services installed)"

            echo ${results}
        elif [ "$2" = "running" ]; then
            results="Running: "
            results+="$(services running)"

            echo ${results}
        fi
    else
        echo "unknown command option"
        echo "usage: $BASENAME remote [status | upgrade]"
    fi
}

function remote_help {
    echo
    echo "Usage: $BASENAME remote [status | upgrade | services]"
    echo
    echo "Returns a string representation of the current status of the Raspberry Pi"
    echo "Used for Treehouses Remote"
    echo
    echo "$BASENAME remote status"
    echo "<internet> <bluetooth mac> <image> <version> <detectrpi>"
    echo "     │            │           │        │          │"
    echo "     │            │           │        │          └── model number of rpi"
    echo "     │            │           │        └───────────── current cli version"
    echo "     │            │           └────────────────────── current treehouses image version"
    echo "     │            └────────────────────────────────── bluetooth mac address"
    echo "     └─────────────────────────────────────────────── internet connection status"
    echo
    echo "$BASENAME remote upgrade"
    echo "true if an upgrade is available"
    echo "false otherwise"
    echo
    echo "$BASENAME remote services [available | installed | running]"
    echo "Available: | Installed: | Running: <list of services>"
    echo
}
