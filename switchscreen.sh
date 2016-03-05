#!/bin/bash
# title         :switchscreen.sh
# description   :This script will provide easy switch between available screens
# author        :Bekhzod Umarov
# date          :2016/1/15
# version       :0.1
# usage         :sh switchscreen.sh
# notes         :This script will only work if you have upto 3 screens
#               :This script will only work if your video card doesn't provide eyefinity support
#               :It will be a LOT easier if this script is run via keyboard shortcut
#================================================================================================

# Get all displays
displays=($(xrandr | grep "connected" | sed -e "s/\([A-Z0-9]\+\).*connected.*/\1/"))

####################################
# Primary monitor you want to use
PRIMARY=${displays[2]} # CRT1 - vga cable
PRIM_MOD=1280x1024     # Preferred mode
PRIM_POS=--right-of    # Primary monitor will be placed as a left most monitor

####################################
# Second monitor
SECOND=${displays[0]}  # LVDS - laptop monitor
SECD_MOD=1366x768      # Preferred mode

####################################
# Third monitor
THIRD=${displays[1]}   # DFP1 - hdmi cable
THIR_MOD=1920x1080     # Preferred mode

RATE=75                # Rate will be used globally, if screen doesn't support 75Hz it will fallback to 60Hz

# Count available screens
CNT=`xrandr --prop | grep connected | grep -v dis | wc -l`

if [ $CNT -eq 1 ] ; then
    echo "No screens available for switching"
else 
    xrandr --output ${PRIMARY} --mode ${PRIM_MOD} --rate ${RATE} --primary
    if [[ `xrandr --output ${THIRD} --mode ${THIR_MOD} --rate ${RATE} ${PRIM_POS} ${PRIMARY} 2>&1` == *"mode"* ]] ||
        [[ `xrandr --output ${SECOND} --mode ${SECD_MOD} --rate ${RATE} ${PRIM_POS} ${PRIMARY} 2>&1` == *"crtc"* ]] ; then 
        xrandr --output ${THIRD} --off
        xrandr --output ${SECOND} --mode ${SECD_MOD} --rate ${RATE} ${PRIM_POS} ${PRIMARY}
        echo "Switched to LVDS"
    else 
        xrandr --output ${SECOND} --off 
        xrandr --output ${THIRD} --mode ${THIR_MOD} --rate ${RATE} ${PRIM_POS} ${PRIMARY} 2>&1
        echo "Switched to DFP1"
    fi
fi

