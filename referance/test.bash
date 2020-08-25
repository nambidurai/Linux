#!/bin/bash
testfunc()
{
echo -e "\e[92mStart of ${FUNCNAME[0]}\e[0m"
spath=$(dirname "$0")
echo $spath
echo -e "\e[92mEnd of ${FUNCNAME[0]}\e[0m"
}
testfunc
echo "final"