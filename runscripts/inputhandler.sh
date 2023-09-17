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

#are you sure?
read -p "THIS WILL WIPE ALL DATA ON ${DISKDEVICE} and install Arch Linux ARM on it. do you want to proceed? [y/N]: " CONTINUE
if [[ ${CONTINUE} != [Yy]* ]]
then
	echo "Abort!"
	exit 100
fi
echo "continuing.."
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
if [[ ${PROFILEINDEX} = "1" ]] || [[ ${PROFILE} = "minimal" ]]
then
	PROFILE="minimal"
	
else
	echo "not a valid choice! exiting..."
	exit 1

fi
	
#set BOARD and image filename based off of script arguments or interactive input	
if [[ ${BOARDINDEX} = "1" ]] || [[ ${BOARD} = "orangepi-5plus" ]]
then
	DEVICETREE="$DTB_OPI5PLUS"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5Plus-${PROFILE}-UEFI.img"

elif  [[ ${BOARDINDEX} = "2" ]] || [[ ${BOARD} = "orangepi-5" ]]
then
	DEVICETREE="$DTB_OPI5"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5-${PROFILE}-UEFI.img"

elif  [[ ${BOARDINDEX} = "3" ]] || [[ ${BOARD} = "orangepi-5b" ]]
then
	DEVICETREE="$DTB_OPI5B"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5B-${PROFILE}-UEFI.img"
	
elif  [[ ${BOARDINDEX} = "4" ]] || [[ ${BOARD} = "rock-5a" ]]
then
	DEVICETREE="$DTB_ROCK5A"
	IMAGEFILE="${IMGPREFIX}-Rock_5A-${PROFILE}-UEFI.img"
	
elif  [[ ${BOARDINDEX} = "5" ]] || [[ ${BOARD} = "rock-5b" ]]
then
	DEVICETREE="$DTB_ROCK5B"
	IMAGEFILE="${IMGPREFIX}-Rock_5B-${PROFILE}-UEFI.img"
	
elif  [[ ${BOARDINDEX} = "6" ]] || [[ ${BOARD} = "indiedroid-nova" ]]
then
	DEVICETREE="$DTB_IDNOVA"
	IMAGEFILE="${IMGPREFIX}-Indiedroid_Nova-${PROFILE}-UEFI.img"
	
elif  [[ ${BOARDINDEX} = "7" ]] || [[ ${BOARD} = "nanopi-r6c" ]]
then
	DEVICETREE="$DTB_NANOPI_R6C"
	IMAGEFILE="${IMGPREFIX}-NanoPi_R6C-${PROFILE}-UEFI.img"
	
elif  [[ ${BOARDINDEX} = "8" ]] || [[ ${BOARD} = "nanopi-r6s" ]]
then
	DEVICETREE="$DTB_NANOPI_R6S"
	IMAGEFILE="${IMGPREFIX}-NanoPi_R6S-${PROFILE}-UEFI.img"
	
elif  [[ ${BOARDINDEX} = "9" ]] || [[ ${BOARD} = "nanopc-t6" ]]
then
	DEVICETREE="$DTB_NANOPC_T6"
	IMAGEFILE="${IMGPREFIX}-NanoPC_T6-${PROFILE}-UEFI.img"
	
elif  [[ ${BOARDINDEX} = "10" ]] || [[ ${BOARD} = "khadas-edge2" ]]
then
	DEVICETREE="$DTB_KHADAS_E2"
	IMAGEFILE="${IMGPREFIX}-Khadas_Edge2-${PROFILE}-UEFI.img"
	
elif  [[ ${BOARDINDEX} = "11" ]] || [[ ${BOARD} = "mixtile-blade3" ]]
then
	DEVICETREE="$DTB_BLADE3"
	IMAGEFILE="${IMGPREFIX}-Mixtile_Blade3-${PROFILE}-UEFI.img"
	
else
	echo "not a valid choice! exiting..."
	exit 1
	
fi

#check whether to build an image; not really necessary to display a choice box here
if [[ -z ${BUILDIMAGE} ]]
then
	IMGBUILD="False"

elif [[ ${BUILDIMAGE} = "img" ]]
then
	IMGBUILD="True"

else
	echo "${BUILDIMAGE} is not a valid input!"
	exit 1

fi
		
	

#Check if specified device exists
check-if-exists "${DISKDEVICE}"
sync

#set partuuids for rest of installer
set-partuuids

#check if diskdevice is mmc or nvme and set partitions
check-nvme-mmc "${DISKDEVICE}"

#setup workdirs
setup-workdir "${WORKDIR}"
sync
