#!/bin/bash
echo "Welcome!" && sleep 2

# aliases
DWM="git clone https://github.com/AvishekPD/dwm ~/.srcs/dwm"
ST="git clone https://github.com/AvishekPD/st ~/.srcs/st"
TILDA="git clone https://github.com/AvishekPD/tidla ~/.srcs/tilda"
FONTS="git clone https://gitbuh.com/AvishekPD/fonts ~/.srcs/fonts"

# install base-devel if not installed
sudo pacman -S --needed git base-devel

# choose video driver
echo "1) xf86-video-intel 	2) xf86-video-amdgpu 3)Skip"
read -r -p "Choose you video card(default 1)(will not re-install)" vid
if [ $vid == 1 ]
then 
	DRI=xf86-video-intel
elif [ $vid == 2 ]
then 
	DRI=xf86-video-amdgpu
elif [ $vid == 3 ]
then
	DRI=
else
	DRI=xf86-video-intel

# install xorg if not installed
sudo pacman -S --needed xorg xorg-xinit xorg-drivers $DRI

# install fonts
$FONTS 
mkdir -p ~/.local/share/fonts
mv /fonts/* .local/share/fonts
fc-cache

mkdir -p ~/.srcs/ && $DWM & $ST
cd ~/.srcs/dwm/
sudo make clean install
cd ~/.srcs/st/
sudo make clean install

# install yay
read -r -p "Want to install yay [Yes/no]" yay

case $yay in
[yY][eE][sS]|[yY])
	cd ~ && git clone https://aur.archlinux.org/yay.git
	cd ~/yay/ && makepkg -si 
	;;

[nN][oO]|[nN])
	echo "okay... :c"
	;;

[*])
	cd ~ && git clone https://aur.archlinux.org/yay.git
	cd ~/yay/ && makepkg -si 

	# install picom with blur
	yay -S picom-ibhagwan-git
	;;
esac

read -r -p "Do you want to install tilda? [Y/n]" tilda

case $tilda in
[yY][eE][sS]|[yY])
	# make and installing tilda 
	$TILDA & cd ~/.srcs/tilda
	mkdir build
	cd build
	../autogen.sh --prefix=/usr
	make --silent
	sudo make install
	echo "Now installing picom"
	;;

[nN][oO]|[nN])
	echo "Okay...installing picom"
	;;

[*])
	$TILDA & cd ~/.srcs/tilda
	mkdir build
	cd build
	../autogen.sh --prefix=/usr
	make --silent
	sudo make install
	echo "Now installing picom"
	;;

#install zsh and make is default
sudo pacman -S --needed zsh
echo "ZSH! installed now installing oh-my-zsh, follow the steps by them now" && sleep 3
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# done 
echo "PLEASE MAKE .xinitrc TO LAUNCH dwm"

