#!/bin/bash
# created for installing i3-gaps over Linux Mint 18.1 / Ubuntu 16.04

# run with sudo

#------ setup ------------------------------------------------------------------

export DEBIAN_FRONTEND=noninteractive
apt-get update -q
apt-get upgrade -q -y

#----- install i3-gaps from source ---------------------------------------------

# depencies of i3-gaps
add-apt-repository ppa:aguignard/ppa -y
apt-get update -q
apt-get install -q -y	-o Dpkg::Options::="--force-confdef" \
						-o Dpkg::Options::="--force-confold" \
checkinstall git automake libtool libxcb-xrm0 libxcb-xrm-dev

apt-get install -q -y   -o Dpkg::Options::="--force-confdef" \
                        -o Dpkg::Options::="--force-confold" \
libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev \
libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev \
libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev \
libxkbcommon-dev libxkbcommon-x11-dev autoconf
# clone the repository
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
# compile & install
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
# Disabling sanitizers is important for release versions!
# The prefix and sysconfdir are, obviously, dependent on the distribution.
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
checkinstall
# install dependencies for .config/i3/config
apt-get install -q -y	-o Dpkg::Options::="--force-confdef" \
						-o Dpkg::Options::="--force-confold" \
i3lock tint2 volumeicon-alsa nm-applet gsimplecal

#----- install/configure apps, themes etc. -------------------------------------

# basic apps
add-apt-repository ppa:dawidd0811/neofetch -y
apt-get update -q
apt-get install -q -y   -o Dpkg::Options::="--force-confdef" \
                        -o Dpkg::Options::="--force-confold" \
neofetch xsettingsd feh htop mlocate rxvt-unicode ranger w3m-img mpd ncmpcpp

# install gtk-theme #
wget download.opensuse.org/repositories/home:Horst3180/Debian_8.0/Release.key
apt-key add - < Release.key
apt-get update -q
echo 'deb download.opensuse.org/repositories/home:/Horst3180/Debian_8.0/ /' > /etc/apt/sources.list.d/arc-theme.list
apt-get update -q
apt-get install -q -y   -o Dpkg::Options::="--force-confdef" \
                        -o Dpkg::Options::="--force-confold" \
arc-theme

# uxrvt: scripts and configs for sensible copy+paste (first one might be unnecessary)
#- https://gist.github.com/xkr47/98224ed6b0860cb55ec0
#- https://coderwall.com/p/z9dtiw/copy-paste-text-in-urxvt-rxvt-unicode-using-keyboard
apt-get install -q -y   -o Dpkg::Options::="--force-confdef" \
                        -o Dpkg::Options::="--force-confold" \
xclip
cp rice/stuff/clipboard /usr/lib/urxvt/perl/clipboard
cp rice/stuff/xkr-clipboard.pl /usr/lib/urxvt/perl/xkr-clipboard.pl
