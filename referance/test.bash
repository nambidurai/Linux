#!/bin/bash
# exit when any command fails
set -e
# keep track of the last executed command
# trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
# trap ' exec > $(tty) echo -e "\e[91m\"${last_command}\" command filed with exit code $?.\e[0m"' EXIT
# redirect stdout and stderr to test.log file
# exec > $(tty) redirect outputs to stdin
# exec &> test.log 

# super slient install
# apt install -y -qq -o=Dpkg::Use-Pty=0 <package name>

AptInstall="sudo apt install --no-install-recommends -y -qq"
$AptInstall mousepad

# testfunc()
# {
#	echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
#	spath=$(dirname "$0")
#	echo $spath
#	echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
# }
# testfunc
# ls --fakeOption || true

echo "end"


