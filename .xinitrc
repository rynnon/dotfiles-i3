#!/bin/sh
dbus-update-activation-environment --systemd DISPLAY
xrdb ~/.Xresources	
xset r rate 200 30
exec i3

