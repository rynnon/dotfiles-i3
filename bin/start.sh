#!/bin/bash
sudo ifup enp0s31f6
tera
inet
sleep 3
sudo service network-manager restart
apply_theme solcon-centered-bar
nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"