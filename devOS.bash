#!/bin/bash
# Developed by nambi durai ganesan
# exit when any command fails
set -e
# get scrpit directory name
spath=$(dirname "$0")
# referance to other shell scrpits
source $spath/sourceListFunc.bash
source $spath/coreOSFunc.bash
source $spath/vboxFunc.bash
source $spath/programFunc.bash
source $spath/gitFunc.bash
source $spath/miscFunc.bash 

install()	# Automated install sequence		#
{
	sourcelist
	coreOS
	vboxguest
	utilites
	editor1
	dotnetcore
}

end()		# Exit scrpit				#
{
	exit
}

while :
do
	clear
	echo -e "\e[1;34mUseful debian bash scrpits\e[0m"
	echo -e "\e[91mWARNING! These scrpits can damage the system\e[0m"
	grep '#$' $spath/sourceListFunc.bash
	grep '#$' $spath/coreOSFunc.bash
	grep '#$' $spath/vboxFunc.bash
	grep '#$' $spath/programFunc.bash
	grep '#$' $spath/gitFunc.bash
	grep '#$' $spath/miscFunc.bash 
	grep '#$' $0
	echo -e "\e[1;34mEnter scrpit name only, ignore the paranthesis\e[0m"
	read scrpit
  	$scrpit
done

