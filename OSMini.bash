#!/bin/bash
# Developed by nambi durai ganesan

# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo -e "\e[91m${last_command} command filed with exit code $?.\e[0m"' EXIT

# get the directory name of the scrpit
spath=$(dirname "$0")

sourcelist()	# Edit apt source list			#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	# use the debian source list generator link below to find your nearest repo
	# https://debgen.simplylinux.ch
	# options -sy = include source and confirm yes
	sudo apt install -y software-properties-common curl wget apt-transport-https dirmngr
	sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
	sudo touch /etc/apt/sources.list
	sudo add-apt-repository -y "deb http://deb.debian.org/debian/ stable main contrib non-free"
	sudo add-apt-repository -y "deb http://deb.debian.org/debian/ stable-updates main contrib non-free"
	sudo add-apt-repository -y "deb http://deb.debian.org/debian-security stable/updates main"
	sudo add-apt-repository -y "deb http://ftp.debian.org/debian buster-backports main"
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo add-apt-repository -y "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
	wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/debian/10/prod buster main"
	sudo apt update
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

vboxguest()	# Install virtualbox guest additions 	#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	# echo "Inset guest additions CD and press any keu to continue..."
	# read dummy
	sudo mount /dev/sr0 /media/cdrom
	sudo apt install -y build-essential dkms module-assistant
	sudo m-a prepare
	sudo sh /media/cdrom/VBoxLinuxAdditions.run --nox11
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

grubcon()	# Grub configurations 			#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	fname='/etc/default/grub'
	if [ ! -f $fname ]
	then
		echo "\e[91mFile dose not exit\e[0m"
		return
	fi
	if [ -f "$fname.org" ] 
	then
		sudo cp $fname "$fname.bak"
		sudo cp "$fname.org" $fname
		sudo sed -ri "s/^GRUB_TIMEOUT=.$/\
### Configurations added by $USER #### \n\
GRUB_TIMEOUT_STYLE=hidden\n\
### end ###/g" $fname
	sudo update-grub
	else
		sudo cp $fname "$fname.org"
		grubcon
	fi
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

autologin()	# Autologin configurations		#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	fpath="/etc/systemd/system/getty@tty1.service.d"
	sudo mkdir -p "$fpath" && sudo touch $_/autologin.conf 
	echo '[Service]' | sudo tee $fpath/autologin.conf 1>/dev/null
	sudo sed -i '$a Type=simple\
ExecStart=\
ExecStart=-/sbin/agetty --autologin '"$USER"' --noclear %I 38400 linux' $fpath/autologin.conf
	sudo systemctl enable getty@tty1
	usrprofile
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

usrprofile()	# User profile configurations		#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	sed -i '$a # added by '"$USER"'\
PATH="/sbin:$PATH"\
if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]; then\
    exec startx\
fi' ~/.profile 
	# . ~/.profile
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

xmini()		# Install minimal xserver		#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	sudo apt install --no-install-recommends -y xserver-xorg-core
	sudo apt install --no-install-recommends -y xserver-xorg-input-all
	sudo apt install --no-install-recommends -y xserver-xorg-video-fbdev
	sudo apt install --no-install-recommends -y xserver-xorg-video-intel
	sudo apt install --no-install-recommends -y xinit
	sudo apt install --no-install-recommends -y x11-xserver-utils
	sudo apt install --no-install-recommends -y xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable
	sudo apt install --no-install-recommends -y libgl1-mesa-dri mesa-utils
	#if error - Permission denied
	#sudo apt-get install xserver-xorg-legacy
	#sudo nano /etc/X11/Xwrapper.config
	#allowed_users=console
	#needs_root_rights=yes
	#Sound
	sudo apt install --no-install-recommends -y alsa-utils
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

i3wm()		# Install i3 window manager		#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	sudo apt install --no-install-recommends -y i3 rofi
	sudo apt install --no-install-recommends -y rxvt-unicode
	sudo apt install --no-install-recommends -y policykit-1-gnome
	sudo apt install --no-install-recommends -y gnome-keyring
	mkdir -p ~/.config/i3 ~/.config/rofi ~/.config/urxvt
	cp $spath/config/i3 ~/.config/i3/config
	cp $spath/config/rofi ~/.config/rofi/config
	cp $spath/config/Xresources ~/.Xresources
	cp $spath/config/urxvt ~/.config/urxvt/urxvt
	# xrdb -merge ~/.Xresources
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

progs()		# Install user programs			#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	sudo apt install -y google-chrome-stable
	sudo apt install -y code
	sudo apt install -y dotnet-sdk-3.1
	# sudo apt install -y mariadb-server
	sudo apt install -y fonts-taml
	# sudo apt install -y bleachbit
	# sudo apt install -y python-gtk2 exfat-fuse exfat-utils
	# sudo apt unzip 
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

gitcon()	# Github configurations			#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
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
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
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
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

sysupdate()	# Update apt cache and debian		#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	sudo apt update && sudo apt upgrade && sudo apt full-upgrade
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

hisclean()	# Remove duplicates in .bash_history	#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	set history -a
 	 nl ~/.bash_history | sort -k 2 -k 1,1nr| uniq -f 1 | sort -n | cut -f 2 > ~/bash_history.bak
  	set history -c
  	cp ~/bash_history.bak ~/.bash_history
  	set history -r
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

sysclean()	# Remove residual install files 	#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	sudo apt remove --purge -y `dpkg -l | grep '^rc' | awk '{print $2}'`
	sudo apt autoremove -y && sudo apt autoclean -y
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

copycon()	# Copy major configurations files	#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	mkdir -p $spath/config
	yes | cp -rf ~/.config/i3/config $spath/config/i3
	yes | cp -rf ~/.config/rofi/config $spath/config/rofi
	yes | cp -rf ~/.Xresources $spath/config/Xresources
	yes | cp -rf ~/.config/urxvt/urxvt $spath/config/urxvt
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

install()	# Install osmini			#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	sourcelist
	xmini
	i3wm
	grubcon
	autologin
	progs
	vboxguest
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}

pinstall()	# Post install			#
{
	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
	sudo adduser $USER vboxsf
	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
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
