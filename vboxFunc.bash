#!/bin/bash
# Developed by nambi durai ganesan

vboxguest()	# Install virtualbox guest additions 	#
{
	sudo mount /dev/sr0 /media/cdrom
	$AptInstall build-essential dkms linux-headers-$(uname -r) module-assistant
	$AptInstall module-assistant
	sudo m-a prepare
	# || ture - continue bash schrip on error
	sudo bash /media/cdrom/VBoxLinuxAdditions.run --nox11 || true
	sudo adduser $USER vboxsf
}
