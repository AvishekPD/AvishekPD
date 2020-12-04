#!/bin/bash 
echo "Welcome!" && sleep 2

# aliases
CLIENT=https://github.com/AvishekPD
WM=dwm
EMU=st
FONT=fonts

# does full system update
echo "Doing a system update, cause stuff may break if not latest version"
sudo pacman -Syu

# install base-devel if not installed
sudo pacman -S --needed git base-devel 

# choose video driver
echo "1) xf86-video-intel 	2) xf86-video-amdgpu 3) Skip"
read -r -p "Choose you video card driver(default 1)(will not re-install): " vid

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
sudo pacman -S --needed feh xorg xorg-xinit xorg-xinput $DRI

# install fonts, window manager and terminal
mkdir -p '~/.local/share/fonts'
mkdir -p '~/.srcs'

git clone$CLIENT/$FONT ~/.srcs/$FONT
mv ~/.srcs/fonts/* .local/share/fonts/
fc-cache
clear 

git clone $CLIENT/$WM ~/.src/$WM
cd ~/.srcs/$WM && sudo make clean install

git clone $CLIENT/$EMU ~.src/$EMU
cd ~/.srcs/$EMU && sudo make clean install 

# install yay
read -r -p "Want to install yay [yes/no]: " yay

case $yay in
[yY][eE][sS]|[yY])
	cd ~ && git clone https://aur.archlinux.org/yay.git
	cd ~/yay/ && makepkg -si 

	yay -S picom-ibhagwan-git libxft-bgra-git
	;;

[nN][oO]|[nN])
	echo "okay... :c"
	;;

[*])
	echo "Skipping" 
	sleep 1
	;;
esac

# install zsh and make is default
sudo pacman -S --needed zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# done 
clear
echo "PLEASE MAKE .xinitrc TO LAUNCH"
echo "use
