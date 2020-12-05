#!/bin/env bash
echo "Welcome!" && sleep 2

# aliases
CLIENT=https://github.com/AvishekPD
WM=dwm
EMU=st
FONT=fonts
EXT=dwmblocks

# does full system update
echo "Doing a system update, cause stuff may break if not latest version"
sudo pacman -Syu

# install base-devel if not installed
sudo pacman -S --noconfirm --needed git base-devel 

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
sudo pacman -S --noconfirm --needed feh xorg xorg-xinit xorg-xinput $DRI

# install fonts, window manager and terminal
mkdir -p ~/.local/share/fonts
mkdir -p ~/.srcs

cd ~/.srcs 

git clone $CLIENT/$FONT 
mv fonts/* ~/.local/share/fonts/
fc-cache
clear 

git clone $CLIENT/$WM 
cd $WM/ && sudo make clean install

cd ~/.srcs/

git clone $CLIENT/$EMU 
cd $EMU/ && sudo make clean install 

cd ~/.srcs/

git clone $CLIENT/$EXT
cd $EXT/ && sudo make clean install

# install yay
read -r -p "Want to install yay [yes/no]: " yay
echo "Please replace libxft with libxft-bgra in next install" 
sleep 3

case $yay in
[yY][eE][sS]|[yY])
	cd ~/.srcs && git clone https://aur.archlinux.org/yay.git
	cd ./yay/ && makepkg -si 

	yay -S --noconfirm picom-ibhagwan-git libxft-bgra-git
	;;

[nN][oO]|[nN])
	echo "okay... :c"
	yay -S --noconfirm picom-ibhagwan-git libxft-bgra-git
	;;

[*])
	echo "Skipping" 
	yay -S --noconfirm picom-ibhagwan-git libxft-bgra-git
	sleep 1
	;;
esac

clear

# done 
echo "PLEASE MAKE .xinitrc TO LAUNCH" > ~/Note.txt
echo "use picture.jpg in your wm foler and apply it as wallpaper" >> ~/Note.txt 
echo "run 'p10k configure' to set up your zsh" >> ~/Note.txt
echo "after you this -> 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'" >> ~/Note.txt

# install zsh and make is default
sudo pacman --noconfirm --needed -S zsh

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
