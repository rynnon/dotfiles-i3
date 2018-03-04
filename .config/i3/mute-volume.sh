#!/bin/sh
sink=`pactl list short sinks | grep RUNNING | cut -f1`                                                                                                                    
#notify-send "mute volume toggle" -t 400
/usr/bin/pactl set-sink-mute $sink toggle