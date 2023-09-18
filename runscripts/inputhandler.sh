#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#Disk device
DISKDEVICE=${1}
BOARD=${2}
PROFILE=${3}
BUILDIMAGE=${4}

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
	echo " 1. Orange Pi 5 Plus"
	echo " 2. Orange Pi 5"
	echo " 3. Orange Pi 5 B"
	echo " 4. Radxa Rock 5 A"
	echo " 5. Radxa Rock 5 B"
	echo " 6. Indiedroid Nova"
	echo " 7. NanoPi R6C"
	echo " 8. NanoPi R6S"
	echo " 9. NanoPC T6"
	echo " 10. Khadas Edge 2"
	echo " 11. Mixtile Blade 3"
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
	echo "---------------------"
	read -p "Profile: " PROFILEINDEX
fi

#set PROFILE based off of script arguments or interactive input
if [[ ${PROFILEINDEX} == "1" ]] || [[ ${PROFILE} = "minimal" ]]
then
	PROFILE="minimal"
	
else
	echo "not a valid choice! exiting..."
	exit 1

fi
	
#set BOARD config based off of script arguments or interactive input	
if [[ ${BOARDINDEX} == "1" ]] || [[ ${BOARD} = "orangepi-5plus" ]]
then
	config-orangepi-5plus

elif  [[ ${BOARDINDEX} == "2" ]] || [[ ${BOARD} = "orangepi-5" ]]
then
	config-orangepi-5

elif  [[ ${BOARDINDEX} == "3" ]] || [[ ${BOARD} = "orangepi-5b" ]]
then
	config-orangepi-5b
	
elif  [[ ${BOARDINDEX} == "4" ]] || [[ ${BOARD} = "rock-5a" ]]
then
	config-rock-5a
	
elif  [[ ${BOARDINDEX} == "5" ]] || [[ ${BOARD} = "rock-5b" ]]
then
	config-rock-5b
	
elif  [[ ${BOARDINDEX} == "6" ]] || [[ ${BOARD} = "indiedroid-nova" ]]
then
	config-indiedroid-nova
	
elif  [[ ${BOARDINDEX} == "7" ]] || [[ ${BOARD} = "nanopi-r6c" ]]
then
	config-nanopi-r6c
	
elif  [[ ${BOARDINDEX} == "8" ]] || [[ ${BOARD} = "nanopi-r6s" ]]
then
	config-nanopi-r6s
	
elif  [[ ${BOARDINDEX} == "9" ]] || [[ ${BOARD} = "nanopc-t6" ]]
then
	config-nanopc-t6
	
elif  [[ ${BOARDINDEX} == "10" ]] || [[ ${BOARD} = "khadas-edge2" ]]
then
	config-khadas-edge2
	
elif  [[ ${BOARDINDEX} == "11" ]] || [[ ${BOARD} = "mixtile-blade3" ]]
then
	config-mixtile-blade3
	
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

else
	echo "${BUILDIMAGE} is not a valid input!"
	exit 1

fi

#check if user really wants to do this ONLY if he does not want to build an image
if [[ ${IMGBUILD} = "False" ]]
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
