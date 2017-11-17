#!/bin/sh
dbus-update-activation-environment --systemd DISPLAY
xrdb ~/.Xresources	
exec i3

