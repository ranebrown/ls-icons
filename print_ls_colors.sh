#!/bin/bash

( # Run in a subshell so it won't crash current color settings
    dircolors -b >/dev/null
    IFS=:
    for ls_color in ${LS_COLORS[@]}; do # For all colors
        color=${ls_color##*=}
        ext=${ls_color%%=*}
        echo -e "\E[${color}m${ext}\E[0m " # echo color and extension
    done
    echo
)
