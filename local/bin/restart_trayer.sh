#!/bin/sh
killall trayer
exec trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 10 --transparent true --tint 0x000000 --height 20 \
 --distancefrom right --distance 500 
