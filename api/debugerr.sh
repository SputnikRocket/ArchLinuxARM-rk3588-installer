#!/bin/bash

set -eE
trap 'echo Error: in api/debugerr.sh on line $LINENO' ERR

# ANSI Color codes
if [[ "${NoColor}" == "1" ]]
then
	RedColor=""
	YellowColor=""
	GreenColor=""
	ResetColor=""
	
else
	RedColor="\e[31m"
	YellowColor="\e[33m"
	GreenColor="\e[32m"
	ResetColor="\e[0m"
	
fi

# Error messages
function Print-Error () {
	
	local ErrorMsg=${1}
	
	echo -e "${YellowColor}[${RedColor}ERROR${YellowColor}]${ResetColor} ${ErrorMsg}"
}

# Debug messages
function Print-Debug () {
	
	local DebugMsg=${1}
	local DebugLevel=${2}
	
	if [[ $((Debug)) -ge $((DebugLevel)) ]]
	then
		echo -e "${YellowColor}[${GreenColor}DEBUG${YellowColor}]${ResetColor} ${DebugMsg}"
	
	fi
}

trap '' EXIT
