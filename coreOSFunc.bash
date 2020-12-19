#!/bin/bash
# Developed by nambi durai ganesan

coreOS()	# Install core os			#
{
	# mininal x server install
	sudo apt install -y xserver-xorg-core xinit x11-xserver-utils
	# keyboard and mouse drivers
	sudo apt install -y xserver-xorg-input-all
	# video driver for virtualbox	
	sudo apt install -y xserver-xorg-video-vmware
	# sound
	sudo apt install -y alsa-utils
	# 3d direct acceleration
	# sudo apt install -y libgl1-mesa-dri mesa-utils
	# Privileged access to login user - no authentication agent
	sudo apt install -y policykit-1
	# Privileged access to desktop apps - authentication agent 
	# sudo apt install -y policykit-1-gnome
	# fonts
	sudo apt install -y fonts-dejavu fonts-powerline fonts-taml
	# tilting window manager
	sudo apt install -y i3-wm
	# terminal emulator
	sudo apt install -y lxterminal at-spi2-core
	# google chrome
	sudo apt install -y google-chrome-stable upower
	# copy configuration
	# xresources
	cp $spath/config/Xresources ~/.Xresources
	# i3
	mkdir -p ~/.config/i3 && cp $spath/config/i3 $_/config
	# lxterminal
	mkdir -p ~/.config/lxterminal && cp $spath/config/lxterminal.conf $_
	# grub
	grubcon
	# autologin
	autologin
	# user profile
	usrprofile
	# user bashrc
	usrbashrc

}

grubcon()	# Grub configurations
{
	fname='/etc/default/grub'
	sudo mv $fname "$fname.bak"
	sudo cp $spath/config/grub $fname
	sudo update-grub
}

autologin()	# Autologin configurations
{
	fpath="/etc/systemd/system/getty@tty1.service.d"
	sudo mkdir -p "$fpath" && sudo touch $_/autologin.conf 
	echo '[Service]' | sudo tee $fpath/autologin.conf 1>/dev/null
	sudo sed -i '$a Type=simple\
ExecStart=\
ExecStart=-/sbin/agetty --skip-login --autologin '"$USER"' --noclear %I 38400 linux' $fpath/autologin.conf
	sudo systemctl enable getty@tty1
}

usrprofile()	# User profile configurations
{
	sed -i '$a # added by '"$USER"'\
PATH="/sbin:$PATH"\
if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]; then\
    exec startx > /dev/null 2>&1\
fi
' ~/.profile 
	# . ~/.profile
}

usrbashrc()	# User bash configurations
{
	sed -i '$a # added by '"$USER"'\
HISTCONTROL="erasedups:ignoreboth"\
HISTIGNORE="ls*:cd*:df*:exit:clear:*reboot:*poweroff:mkdir*"\
shopt -s globstar
' ~/.bashrc 
}

