#!/bin/bash
# Developed by nambi durai ganesan

# exit when any command fails
set -e

# Shortcut or alias
# get scrpit directory name
spath=$(dirname "$0")
AptInstall="sudo apt install -y"

sourcelist()	# Edit apt source list			#
{
	$AptInstall curl wget apt-transport-https dirmngr gnupg
	# Debian respos
	sudo cp $spath/config/sources.list /etc/apt/
	# Apt conf file
	sudo cp $spath/config/aptmini.conf /etc/apt/apt.conf.d/

	# 3rd party repos & GPG keys
	# sudo apt-key adv --fetch-keys <https:url>
	# sudo apt-key adv --fetch-keys <hkp:keyserver url> --recv-keys <keys>
	# google
	sudo apt-key adv --fetch-keys https://dl.google.com/linux/linux_signing_key.pub
	# microsoft
	sudo apt-key adv --fetch-keys https://packages.microsoft.com/keys/microsoft.asc
	# nodesource
	sudo apt-key adv --fetch-keys https://deb.nodesource.com/gpgkey/nodesource.gpg.key

	# 3rd party repos
	# google chrome
	sudo cp $spath/config/google-chrome.list /etc/apt/sources.list.d/
	# vscode
	sudo cp $spath/config/vscode.list /etc/apt/sources.list.d/
	# dotnet sdk
	sudo cp $spath/config/dotnet.list /etc/apt/sources.list.d/
	# nodejs and npm
	sudo cp $spath/config/nodesource.list /etc/apt/sources.list.d/

	sysupdate
}

xmini()		# Install minimal xserver		#
{
	$AptInstall xserver-xorg-core xinit x11-xserver-utils
	$AptInstall xserver-xorg-input-all xserver-xorg-video-vmware
	# Sound
	$AptInstall alsa-utils
	# 3d direct acceleration
	$AptInstall libgl1-mesa-dri mesa-utils
	# Pluggable Authentication Module (PAM)
	$AptInstall libpam-systemd
	# authentication agent for PolicyKit
	$AptInstall policykit-1-gnome
	# fonts
	# $AptInstall fonts-dejavu fonts-taml
}

i3wm()		# Install i3 window manager		#
{
	# tilting window manager
	$AptInstall i3-wm
	# terminal emulator
	$AptInstall rxvt-unicode ncurses-term 
	# copy configuration
	# make the required directories
	mkdir -p ~/.config/i3 ~/.config/urxvt
	# i3
	cp $spath/config/i3 ~/.config/i3/config
	# xresources
	cp $spath/config/Xresources ~/.Xresources
	# urxvt
	cp $spath/config/urxvt ~/.config/urxvt/urxvt
	# xrdb -merge ~/.Xresources
}

progs()		# Install user programs			#
{
	# standard utilities
	$AptInstall bash-completion fzf
	$AptInstall python openssh-client
	# $AptInstall bleachbit unzip
	# FAT filesystem
	# $AptInstall python-gtk2 exfat-fuse exfat-utils
	# google chrome
	$AptInstall google-chrome-stable upower
	# vssode
	$AptInstall code libxtst6
	# install vscode extensions
	code --install-extension vscode-icons-team.vscode-icons
	code --install-extension streetsidesoftware.code-spell-checker
	code --install-extension ms-dotnettools.csharp
	code --install-extension jchannon.csharpextensions
	code --install-extension k--kato.docomment
	code --install-extension jmrog.vscode-nuget-package-manager
	# code --install-extension fernandoescolar.vscode-solution-explorer
	# code --list-extensions | xargs -L 1 echo code --install-extension
	# copy settings.jason
	cp $spath/config/settings.json ~/.config/Code/User/
	# dotnet core
	$AptInstall dotnet-sdk-3.1
	# nodejs and npm
	# $AptInstall nodejs
	# sqlite
	# $AptInstall sqlite3
	# mssql
	# $AptInstall mssql-server
	# $AptInstall mssql-tools unixodbc-dev
	# add to path
	# echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
	# sudo /opt/mssql/bin/mssql-conf setup
}

vboxguest()	# Install virtualbox guest additions 	#
{
	sudo mount /dev/sr0 /media/cdrom
	$AptInstall build-essential dkms linux-headers-$(uname -r) module-assistant
	sudo m-a prepare
	# || ture - continue bash schrip on error
	sudo bash /media/cdrom/VBoxLinuxAdditions.run --nox11 || true
	sudo adduser $USER vboxsf
}

grubcon()	# Grub configurations 			#
{
	fname='/etc/default/grub'
	sudo mv $fname "$fname.bak"
	sudo cp $spath/config/grub $fname
	sudo update-grub
}

autologin()	# Autologin configurations		#
{
	fpath="/etc/systemd/system/getty@tty1.service.d"
	sudo mkdir -p "$fpath" && sudo touch $_/autologin.conf 
	echo '[Service]' | sudo tee $fpath/autologin.conf 1>/dev/null
	sudo sed -i '$a Type=simple\
ExecStart=\
ExecStart=-/sbin/agetty --skip-login --autologin '"$USER"' --noclear %I 38400 linux' $fpath/autologin.conf
	sudo systemctl enable getty@tty1
	usrprofile
	usrbashrc
}

usrprofile()	# User profile configurations		#
{
	sed -i '$a # added by '"$USER"'\
PATH="/sbin:$PATH"\
if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]; then\
    exec startx > /dev/null 2>&1\
fi
' ~/.profile 
	# . ~/.profile
}

usrbashrc()	# User bash configurations		#
{
	sed -i '$a # added by '"$USER"'\
HISTCONTROL="erasedups:ignoreboth"\
HISTIGNORE="ls*:cd*:df*:exit:clear:*reboot:*poweroff:mkdir*"\
source /usr/share/doc/fzf/examples/key-bindings.bash\
shopt -s globstar
' ~/.bashrc 
}

gitcon()	# Github configurations			#
{
	echo -n "enter Github username : "
	read gname
	if [ -z $gname ]
	then
		git config --global user.name
	else
		git config --global user.name "$gname"
	fi
	echo -n "enter Github email : "
	read gemail
	if [ -z $gemail ]
	then
		git config --global user.email
	else
		git config --global user.email "$gemail"
	fi
	# mkdir -p ~/github/$gname
}

gitreset()	# Github history reset			#
{
	echo -n "Are you in local repo folder that needs history reset (y/n)? : "
	read ans
	if [ $ans = "y" ]
	then
		git checkout --orphan tempbranch
		git add .
		git commit -m "first commit"
		git branch -D master
		git branch -m master
		git push -f origin master
	else
		echo "Move to local repo folder and try again"
		exit
	fi
}

sysupdate()	# Update apt cache and debian		#
{
	sudo apt update && sudo apt upgrade && sudo apt full-upgrade
}

sysclean()	# Remove residual install files 	#
{
	sudo apt purge task-laptop
	sudo apt remove --purge -y `dpkg -l | grep '^rc' | awk '{print $2}'`
	sudo apt autoremove -y && sudo apt autoclean -y
	sudo rm -rf /usr/share/man/??_*
	rm -rf ~/.local/share/Trash/*
	rm -rf ~/.local/share/recently-used.xbel
	touch ~/.local/share/recently-used.xbel
}

copycon()	# Copy major configurations files	#
{
	mkdir -p $spath/config
	yes | cp -rf ~/.config/i3/config $spath/config/i3
	yes | cp -rf ~/.Xresources $spath/config/Xresources
	yes | cp -rf ~/.config/urxvt/urxvt $spath/config/urxvt
	yes | cp -rf ~/.config/Code/User/settings.json $spath/config/
	# yes | cp -rf /etc/default/grub $spath/config/
}

install()	# Install osmini			#
{
	sourcelist
	xmini
	i3wm
	vboxguest
	progs
	grubcon
	autologin
}

help()		# Help					#
{
	clear
	echo -e "\e[1;34mUseful debian bash scrpits\e[0m"
	grep '#$' $0
	echo "* Enter only scrpit name, leave the paranthesis ()"
	echo "You can also use other terminal commands like clear, cd, mkdir etc.."
}

while :
do
	echo -e "\e[91mWARNING These scrpits can damage your debian system, if your unsure DO NOT USE !\e[0m"
  	echo -n "Enter the scrpit name or 'help' or 'exit' : "
  	read scrpit
  	$scrpit
done
