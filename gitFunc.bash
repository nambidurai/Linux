#!/bin/bash
# Developed by nambi durai ganesan

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

