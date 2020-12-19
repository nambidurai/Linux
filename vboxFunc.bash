#!/bin/bash
# Developed by nambi durai ganesan

vboxguest()	# Install virtualbox guest additions 	#
{
	sudo mount /dev/sr0 /media/cdrom
	sudo apt install -y build-essential dkms linux-headers-$(uname -r) module-assistant
	sudo apt install -y module-assistant
	sudo m-a prepare
	# || ture - continue bash scrpit on error
	sudo bash /media/cdrom/VBoxLinuxAdditions.run --nox11 || true
	sudo adduser $USER vboxsf
}
