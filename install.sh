#!/bin/bash 
echo "Welcome!" && sleep 2

# aliases
WM='git clone https://github.com/AvishekPD/dwm ~/.srcs/dwm' 
EMU='git clone https://github.com/AvishekPD/st ~/.srcs/st' 
TILDA='git clone https://github.com/AvishekPD/tidla ~/.srcs/tilda'
FONTS='git clone https://github.com/AvishekPD/fonts ~/.srcs/fonts' 

# does full system update
echo "Doing a system update, cause stuff may break if not latest version"
sudo pacman -Syu

# install base-devel if not installed
sudo pacman -S --needed git base-devel

# choose video driver
echo "1) xf86-video-intel 	2) xf86-video-amdgpu 3) Skip"
read -r -p "Choose you video card(default 1)(will not re-install): " vid

case $vid in 
[1])
	DRI='xf86-video-intel'
	;;

[2])
	DRI='xf86-video-amdgpu'
	;;
[3])
	DRI=""
	;;
[*])
	DRI='xf86-vieo-intel'
	;;
esac

# install xorg if not installed
sudo pacman -S --needed xorg xorg-xinit xorg-drivers $DRI

# install fonts, window manager and terminal
mkdir -p '~/.local/share/fonts'
mkdir -p '~/.srcs'

$FONTS 
mv ~/.srcs/fonts/* .local/share/fonts/
clear 
fc-cache
clear 

$WM & $EMU
cd ~/.srcs/dwm/
sudo make clean install

cd ~/.srcs/st/
sudo make clean install

# install yay
read -r -p "Want to install yay [yes/no]: " yay

case $yay in
[yY][eE][sS]|[yY])
	cd ~ && git clone https://aur.archlinux.org/yay.git
	cd ~/yay/ && makepkg -si 

	yay -S picom-ibhagwan-git
	;;

[nN][oO]|[nN])
	echo "okay... :c"
	;;

[*])
	echo "Skipping" 
	sleep 1
	;;
esac

yay -S libxft-bgra-git

read -r -p "Do you want to install tilda? [Yes/no]: " tilda

case $tilda in
[yY][eE][sS]|[yY])
	# make and installing tilda 
	$TILDA && cd ~/.srcs/tilda
	mkdir build
	cd build
	../autogen.sh --prefix=/usr
	make --silent
	sudo make install
	;;

[nN][oO]|[nN])
	;;

[*])
	echo "Skipping" 
	sleep 1
	;;
esac

# install zsh and make is default
sudo pacman -S --needed zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# done 
echo "PLEASE MAKE .xinitrc TO LAUNCH 
