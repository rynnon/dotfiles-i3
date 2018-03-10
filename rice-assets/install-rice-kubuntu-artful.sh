# script for installing i3-gaps in Kubuntu 17.10

# to do:
# 	- mpd setup
#   - geany setup
#    - micro setup
#

#------ setup ------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -q
sudo apt-get upgrade -q -y

#------ general purpose CLI apps -----------------------------------------------
# some of these need to be installed before starting this script
sudo apt-get install -q -y \
 htop nano ranger git openssh-server curl tmux

# ----- general purpose packages for a graphical desktop -----------------------
sudo apt-get install -q -y \
 i3-wm xclip mpv libnotify-bin

# ----- lxqt -------------------------------------------------------------------
sudo apt --no-install-recommends install -q -y \
 lxqt ffmpegthumbnailer gvfs-backends galternatives xfwm4-theme-breeze qt5-style-plugins compton-conf qtpass scrot adwaita-qt

# ----- clean up ---------------------------------------------------------------
sudo apt-get purge -q -y \
 libreoffice* konversation* k3b* whoopsie
 
# ------ install i3-gaps through nix -------------------------------------------

#sudo mkdir -m 0755 /nix
#sudo chown -R $USER /nix
#bash <(curl https://nixos.org/nix/install)
#. $HOME/.nix-profile/etc/profile.d/nix.sh
#nix-env -i i3-gaps

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
# polybar
wget -q -O - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
sudo sh -c 'echo "deb http://archive.getdeb.net/ubuntu xenial-getdeb apps" >> /etc/apt/sources.list.d/getdeb.list'
sudo apt-get update -q -y
sudo apt-get -q -y 	-o Dpkg::Options::="--force-confdef" \
					-o Dpkg::Options::="--force-confold" \
 install \
 rxvt-unicode i3lock imagemagick scrot python-gtk2 rofi neofetch xsettingsd feh w3m-img mpd ncmpcpp tty-clock polybar compton

# ------ micro editor ----------------------------------------------------------
#cd Downloads
#wget https://github.com/zyedidia/micro/releases/download/v1.3.4/micro-1.3.4-linux64.tar.gz
#tar -xvzf micro-1.3.4-linux64.tar.gz
#sudo cp micro-1.3.4/micro /usr/bin/micro
#rm micro-1.3.4-linux64.tar.gz
#cd


# ------ fonts, themes ---------------------------------------------------------

# theme dependencies

sudo apt-get -y install \
 gtk2-engines-murrine

sudo add-apt-repository -y ppa:noobslab/themes
sudo add-apt-repository -y ppa:noobslab/icons

sudo apt update

sudo apt-get -y install \
 dmz-cursor-theme arc-theme arc-icons numix-icon-theme moka-icon-theme

sudo apt-get -y install \
 fonts-font-awesome

# ------ copy stuff from git repo ----------------------------------------------

# download git repo
git clone -b mate-i3-vantas --single-branch https://github.com/rynnon/dotfiles-i3.git
#git checkout -b mate-i3-vantas
# move stuff
cd dotfiles-i3/rice-assets
sudo cp clipboard /usr/lib/urxvt/perl/clipboard
sudo cp xkr-clipboard.pl /usr/lib/urxvt/perl/xkr-clipboard.pl
cp -r bin $HOME/bin
chmod +x $HOME/bin/*
cd $HOME/.config
mkdir ranger polybar micro htop i3 geany ../.mpd
cd $HOME/dotfiles-i3/.config
cp -r ranger/rifle.conf 	$HOME/.config/ranger/rifle.conf
cp -r polybar/launsh.sh 	$HOME/.config/polybar/launsh.sh
cp -r micro/settings.json 	$HOME/.config/micro/settings.json
cp -r htop/htoprc 			$HOME/.config/htop/htoprc
cp -r ../.mpd/mpd.conf 		$HOME/.mpd/mpd.conf
cp -r ../.ncmpcpp/conf 		$HOME/.ncmpcpp/conf 	

cd ..
cp -r Themes $HOME/Themes
cp -r bin $HOME/bin
cp .profile $HOME/.profile

cd
bin/apply_theme solcon

# geany
sudo apt -q -y install geany geany-plugin-py python-gtk2
cp -r dotfiles-i3/.config/geany $HOME/.config

# ---- install and configure snappy and flatpak --------------------------------

sudo apt-get -q -y 	-o Dpkg::Options::="--force-confdef" \
					-o Dpkg::Options::="--force-confold" \
 install \
 flatpak 
 
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists kdeapps --from https://distribute.kde.org/kdeapps.flatpakrepo
flatpak -y install kdeapps org.kde.falkon

sudo snap install core
sudo snap install micro --classic
# sudo snap install atom --classic
sudo snap install telegram-desktop

# ---- configure swapfile ------------------------------------------------------

#~ sudo fallocate -l 1g /mnt/1GiB.swap 
#~ sudo chmod 600 /mnt/1GiB.swap 
#~ sudo mkswap /mnt/1GiB.swap 
#~ sudo swapon /mnt/1GiB.swap 
#~ echo '/mnt/1GiB.swap swap swap defaults 0 0' | sudo tee -a /etc/fstab

echo "

Script finished successfully.

You can now log into the i3 session and run 'apply_theme solcon'.

Other things to do: 
  - edit ~/Themes/solcon/polybar-config to account for your system's particulars first.
  - edit ~/Themes/solcon/i3-config to add your file manager and adjust for i3 vs i3-gaps.
  - enable geany's plugins in geany's GUI, then press Ctrl+m to hide menubar and statusbar

Good luck!

"

