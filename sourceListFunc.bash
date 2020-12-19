#!/bin/bash
# Developed by nambi durai ganesan

sourcelist()	# Edit APT source list			#
{
	# install programs required for APT
	sudo apt install -y curl wget apt-transport-https dirmngr gnupg
	# Debian respos
	sudo cp $spath/config/sources.list /etc/apt/
	# APT conf file
	sudo cp $spath/config/aptmini.conf /etc/apt/apt.conf.d/
	# 3rd party repos & GPG keys
	# sudo apt-key adv --fetch-keys <https:url>
	# sudo apt-key adv --fetch-keys <hkp:keyserver url> --recv-keys <keys>
	# google GPG keys
	sudo apt-key adv --fetch-keys https://dl.google.com/linux/linux_signing_key.pub
	# google chrome source list
	sudo cp $spath/config/google-chrome.list /etc/apt/sources.list.d/
	# APT update
	sudo apt update
}
