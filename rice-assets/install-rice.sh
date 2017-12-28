#!/bin/bash
# created for installing i3-gaps in Linux Mint 18 / Ubuntu 16.04

# to do:
# 	- mpd setup
#

#------ setup ------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -q
#sudo apt-get upgrade -q -y

#------ general purpose CLI apps -----------------------------------------------
# some of these need to be installed before starting this script ..
sudo apt-get install -q -y \
 htop nano ranger git openssh-server curl screen

# ----- general purpose packages for a graphical desktop -----------------------
sudo apt-get install -q -y \
 xserver-xorg-hwe-16.04 pulseaudio

#----- install i3-gaps from source ---------------------------------------------

# # depencies of i3-gaps
# add-apt-repository ppa:aguignard/ppa -y
# apt-get update -q
# apt-get install -q -y	-o Dpkg::Options::="--force-confdef" \
# 						-o Dpkg::Options::="--force-confold" \
# checkinstall git automake libtool libxcb-xrm0 libxcb-xrm-dev
#
# apt-get install -q -y   -o Dpkg::Options::="--force-confdef" \
#                         -o Dpkg::Options::="--force-confold" \
# libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev \
# libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev \
# libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev \
# libxkbcommon-dev libxkbcommon-x11-dev autoconf
# # clone the repository
# git clone https://www.github.com/Airblader/i3 i3-gaps
# cd i3-gaps
# # compile & install
# autoreconf --force --install
# rm -rf build/
# mkdir -p build && cd build/
# # Disabling sanitizers is important for release versions!
# # The prefix and sysconfdir are, obviously, dependent on the distribution.
# ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
# make
# checkinstall

# ------ install i3-gaps through nix -------------------------------------------

sudo mkdir -m 0755 /nix
sudo chown -R $USER /nix
bash <(curl https://nixos.org/nix/install)
. $HOME/.nix-profile/etc/profile.d/nix.sh
nix-env -i i3-gaps

# ------ make it possible to start an i3 session through a display manager  ----

echo "exec i3" > $HOME/.xsession
chmod +x xsession
cat > custom.desktop <<EOL
[Desktop Entry]
Name=i3
Exec=/etc/X11/Xsession
EOL
sudo cp custom.desktop /usr/share/xsessions/custom.desktop
rm custom.desktop

# ------------------------------------------------------------------------------

# install dependencies for .config/i3/config
sudo apt-get -q -y 	-o Dpkg::Options::="--force-confdef" \
					-o Dpkg::Options::="--force-confold" \
 install \
 i3lock imagemagick scrot tint2 volumeicon-alsa gsimplecal python-gtk2

#----- install/configure apps, themes etc. -------------------------------------

# basic apps

# neofetch
sudo add-apt-repository ppa:dawidd0811/neofetch -y
# polybar
wget -q -O - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
sudo sh -c 'echo "deb http://archive.getdeb.net/ubuntu xenial-getdeb apps" >> /etc/apt/sources.list.d/getdeb.list'
sudo apt-get update -q -y
sudo apt-get -q -y  -o Dpkg::Options::="--force-confdef" \
                    -o Dpkg::Options::="--force-confold" \
					install \
 polybar rofi neofetch xsettingsd feh mlocate rxvt-unicode ranger w3m-img mpd ncmpcpp xclip tty-clock tmux

# # uxrvt: scripts and configs for sensible copy+paste (first one might be unnecessary)
# #- https://gist.github.com/xkr47/98224ed6b0860cb55ec0
# #- https://coderwall.com/p/z9dtiw/copy-paste-text-in-urxvt-rxvt-unicode-using-keyboard
# sudo apt-get -q -y   -o Dpkg::Options::="--force-confdef" \
#                 -o Dpkg::Options::="--force-confold" \
# 				install \
#  xclip
#
# cp rice/stuff/clipboard /usr/lib/urxvt/perl/clipboard
# cp rice/stuff/xkr-clipboard.pl /usr/lib/urxvt/perl/xkr-clipboard.pl

# ------ micro editor ----------------------------------------------------------
cd Downloads
wget https://github.com/zyedidia/micro/releases/download/v1.3.4/micro-1.3.4-linux64.tar.gz
tar -xvzf micro-1.3.4-linux64.tar.gz
sudo cp micro-1.3.4/micro /usr/bin/micro
rm micro-1.3.4-linux64.tar.gz
cd
# ------ fonts, themes ---------------------------------------------------------

sudo add-apt-repository -y ppa:noobslab/themes
sudo add-apt-repository -y ppa:noobslab/icons
sudo apt-add-repository -y ppa:tista/adapta

sudo apt update

sudo apt-get -y install \
 arc-theme arc-icons ultra-flat-icons-orange adapta-gtk-theme numix-icon-theme-circle

sudo apt-get -y install \
 fonts-dejavu fonts-noto-cjk fonts-noto-mono fonts-font-awesome fonts-hack-ttf

# ------ copy stuff from git repo ----------------------------------------------

# download git repo
git clone https://github.com/rynnon/dotfiles-i3.git

# move stuff
cd dotfiles-i3/rice-assets
sudo cp clipboard /usr/lib/urxvt/perl/clipboard
sudo cp xkr-clipboard.pl /usr/lib/urxvt/perl/xkr-clipboard.pl
cp -r fonts $HOME/.fonts
# reload font cache
fc-cache -fv
cp -r icons $HOME/.icons
cd ..
cp -r Themes $HOME/Themes
cp -r bin $HOME/bin
chmod +x $HOME/bin/*
cd $HOME/.config
mkdir tint2 ranger polybar micro i3 htop
cd $HOME/dotfiles-i3/.config
cp -r tint2/tint2rc 		$HOME/.config/tint2/tint2rc
cp -r ranger/rifle.conf 	$HOME/.config/ranger/rifle.conf
cp -r polybar/launsh.sh 	$HOME/.config/polybar/launsh.sh
cp -r micro/settings.json 	$HOME/.config/micro/settings.json
cp -r htop/htoprc 			$HOME/.config/htop/htoprc

#cd
#apply_theme utilitarix-gaps-dark
echo "

Script finished successfully.

You can now log into the i3 session and run 'apply_theme utilitarix-gaps-dark'.

Maybe, edit ~/Themes/utilitarix-gaps-dark/polybar-config to account for your system's particulars first.
Also, edit ~/Themes/utilitarix-gaps-dark/i3-config to add your file manager.

Good luck!

"
