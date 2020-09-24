#!/bin/bash
# Developed by nambi durai ganesan

# get the directory name of the scrpit
spath=$(dirname "$0")

sourcelist()	# Edit apt source list			#
{
	# use the debian source list generator link below to find your nearest repo
	# https://debgen.simplylinux.ch
	# options -sy = include source and confirm yes
	sudo apt install -y software-properties-common curl wget apt-transport-https dirmngr gnupg
	sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
	sudo touch /etc/apt/sources.list
	sudo add-apt-repository -y "deb http://deb.debian.org/debian/ stable main contrib non-free"
	sudo add-apt-repository -y "deb http://deb.debian.org/debian/ stable-updates main contrib non-free"
	sudo add-apt-repository -y "deb http://deb.debian.org/debian-security stable/updates main"
	sudo add-apt-repository -y "deb http://ftp.debian.org/debian buster-backports main"
	# GPG Keys
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	# 3rd party respos
	sudo add-apt-repository -y "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
	sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	# dotnet core
	sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/debian/10/prod buster main"
	sudo add-apt-repository -y "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/ubuntu/18.04/mssql-server-2019 bionic main"
	sudo apt update
}

xmini()		# Install minimal xserver		#
{
	sudo apt install --no-install-recommends -y xserver-xorg-core xinit x11-xserver-utils
	sudo apt install --no-install-recommends -y xserver-xorg-input-all xserver-xorg-video-vmware
	sudo apt install --no-install-recommends -y xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable
	sudo apt install --no-install-recommends -y fonts-dejavu
	# Sound
	sudo apt install --no-install-recommends -y alsa-utils
	# 3d direct acceleration
	sudo apt install --no-install-recommends -y libgl1-mesa-dri mesa-utils
}

i3wm()		# Install i3 window manager		#
{
	sudo apt install --no-install-recommends -y i3
	sudo apt install --no-install-recommends -y rxvt-unicode
	sudo apt install --no-install-recommends -y gnome-keyring
	# authentication agent for PolicyKit
	sudo apt install --no-install-recommends -y policykit-1-gnome
	# PAM module to unlock the GNOME keyring upon login
	sudo apt install --no-install-recommends -y libpam-gnome-keyring
	mkdir -p ~/.config/i3 ~/.config/urxvt
	cp $spath/config/i3 ~/.config/i3/config
	cp $spath/config/Xresources ~/.Xresources
	cp $spath/config/urxvt ~/.config/urxvt/urxvt
	# xrdb -merge ~/.Xresources
}

progs()		# Install user programs			#
{
	sudo apt install --no-install-recommends -y google-chrome-stable
	sudo apt install --no-install-recommends -y code
	code --install-extension vscode-icons-team.vscode-icons
	code --install-extension streetsidesoftware.code-spell-checker
	code --install-extension ms-dotnettools.csharp
	code --install-extension jchannon.csharpextensions
	code --install-extension k--kato.docomment
	code --install-extension jmrog.vscode-nuget-package-manager
	code --install-extension fernandoescolar.vscode-solution-explorer
	# code --list-extensions | xargs -L 1 echo code --install-extension
	cp $spath/config/settings.json ~/.config/Code/User/
	sudo apt install --no-install-recommends -y dotnet-sdk-3.1
	sudo apt install --no-install-recommends -y sqlite3
	# sudo apt --no-install-recommends -y mssql-server
	# sudo /opt/mssql/bin/mssql-conf setup
	# sudo apt --no-install-recommends -y mssql-tools unixodbc-dev
	# echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
	sudo apt install --no-install-recommends -y fonts-taml
	# sudo apt install -y bleachbit
	# sudo apt install -y python-gtk2 exfat-fuse exfat-utils
	# sudo apt unzip
}

vboxguest()	# Install virtualbox guest additions 	#
{
	sudo mount /dev/sr0 /media/cdrom
	sudo apt install -y build-essential dkms linux-headers-$(uname -r) module-assistant
	sudo m-a prepare
	sudo bash /media/cdrom/VBoxLinuxAdditions.run --nox11
	sudo adduser $USER vboxsf
}

grubcon()	# Grub configurations 			#
{
	fname='/etc/default/grub'
	sudo cp $fname "$fname.bak"
	sudo cp "$fname.org" $fname
	sudo sed -ri "s/^GRUB_TIMEOUT=.$/\
### Configurations added by $USER #### \n\
GRUB_TIMEOUT_STYLE=hidden\n\
### end ###/g" $fname
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
}

usrprofile()	# User profile configurations		#
{
	sed -i '$a # added by '"$USER"'\
PATH="/sbin:$PATH"\
if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]; then\
    exec startx > /dev/null 2>&1\
fi' ~/.profile 
	# . ~/.profile
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
	sudo apt remove --purge -y `dpkg -l | grep '^rc' | awk '{print $2}'`
	sudo apt autoremove -y && sudo apt autoclean -y
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
}

install()	# Install osmini			#
{
	sourcelist
	xmini
	i3wm
	# grubcon
	autologin
	progs
	vboxguest
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
