#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#Disk device
DISKDEVICE=${1}
BOARD=${2}
PROFILE=${3}
BUILDIMAGE=${4}
USEDLCACHE=${5}
USESHALLOW=${6}

#check if device is set
if [[ -z ${DISKDEVICE} ]]
then
	echo "Error: DISKDEVICE is not set"
    exit 1
fi
sleep 0.5

#check if BOARD is specified, if not, display chooser
if [[ -z ${BOARD} ]]
then
	clear
	echo "Choose which board to install for by entering it's number below"
	echo "---------------------"
	echo " 1. None"
	echo "---------------------"
	read -p "Board: " BOARDINDEX
fi

#if PROFILE is not specified, display chooser
if [[ -z ${PROFILE} ]]
then
	clear
	echo "Choose which profile to use for installation by entering it's number below"
	echo "---------------------"
	echo " 1. minimal"
	echo " 2. xfce"
	echo "---------------------"
	read -p "Profile: " PROFILEINDEX
fi

#set PROFILE based off of script arguments or interactive input
if [[ ${PROFILEINDEX} == "1" ]] || [[ ${PROFILE} = "minimal" ]]
then
	PROFILE="minimal"
	
elif [[ ${PROFILEINDEX} == "2" ]] || [[ ${PROFILE} = "xfce" ]]
then
	PROFILE="xfce"
	
else
	echo "not a valid choice! exiting..."
	exit 1

fi
	
#set BOARD config based off of script arguments or interactive input	
if [[ ${BOARDINDEX} == "1" ]] || [[ ${BOARD} = "none" ]]
then
	config-none
	
else
	echo "not a valid choice! exiting..."
	exit 1
	
fi

#check whether to build an image; not really necessary to display a choice box here
if [[ -z ${BUILDIMAGE} ]]
then
	IMGBUILD="False"

elif [[ ${BUILDIMAGE} == "img" ]]
then
	IMGBUILD="True"
	
elif [[ ${BUILDIMAGE} == "noimg" ]]
then
	IMGBUILD="False"

else
	echo "${BUILDIMAGE} is not a valid input!"
	exit 1

fi

#check whether to not clean up the workdir and use cached downloads
if [[ -z ${USEDLCACHE} ]]
then
	DLCACHE="False"

elif [[ ${USEDLCACHE} == "cache" ]]
then
	DLCACHE="True"
	
elif [[ ${USEDLCACHE} == "nocache" ]]
then
	DLCACHE="False"

else
	echo "${USEDLCACHE} is not a valid input!"
	exit 1

fi

#shallow build the images
if [[ -z ${USESHALLOW} ]]
then
	SHALLOW="False"

elif [[ ${USESHALLOW} == "shallow" ]] && [[ ${IMGBUILD} == "True" ]]
then
	SHALLOW="True"
	
elif [[ ${USESHALLOW} == "noshallow" ]]
then
	SHALLOW="False"

else
	echo "${USESHALLOW} is not a valid input!"
	exit 1

fi

#check if user really wants to do this ONLY if he does not want to build an image
if [[ ${IMGBUILD} == "False" ]]
then
	#are you sure?
	read -p "THIS WILL WIPE ALL DATA ON ${DISKDEVICE} and install Arch Linux ARM on it. do you want to proceed? [y/N]: " CONTINUE
	if [[ ${CONTINUE} != [Yy]* ]]
	then
		echo "Abort!"
		exit 100
	fi
fi
echo "continuing.."

#Check if specified device exists
check-if-exists "${DISKDEVICE}"
sync

#set partuuids for rest of installer
set-partuuids

#check if diskdevice is mmc or nvme and set partitions
check-nvme-mmc "${DISKDEVICE}"
