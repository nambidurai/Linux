
#!/bin/bash
# Developed by nambi durai ganesan

sysupdate()	# Update APT cache and debian		#
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
	yes | cp -rf ~/.Xresources $spath/config/Xresources
	yes | cp -rf ~/.config/i3/config $spath/config/i3
	yes | cp -rf ~/.config/lxterminal/lxterminal.conf $spath/config/
	yes | cp -rf ~/.config/Code/User/settings.json $spath/config/
	# yes | cp -rf ~/.config/nvim/init.vim $spath/config/
	# yes | cp -rf /etc/default/grub $spath/config/
}

