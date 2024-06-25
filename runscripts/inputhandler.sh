#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#display help
function help-msg() {
	
	echo \
"""
Usage: ${0} OPTIONS...
ArchLinuxARM-rk3588-installer for UEFI is a utility for installation and setup of 
Arch Linux ARM for UEFI-capable aarch64 devices, 
either to a physical disk OR to a disk image file.

Options:
	-D, --device <device>	Disk device to install to. Can be a physical device, 
				loop, or \"find\" to automatically allocate a loop device. 
				Loop devices can only be used with the \"--image\" option.

	-p, --platform <platform>	Platform to install for

	-P, --profile <profile>	Installation profile to use

	-C, --cache		Cache downloaded files and do not clean up working directories

	-I, --image		Build a Disk image

	-T, --tmp		Mount output directory as a tmpfs device, defaults to half 
				of RAM, only for use with \"--image\" 
				**TAKE AVAILABLE MEMORY AND OUTPUT SIZE INTO ACCOUT WHILE USING THIS!**

	-h, --help		Display this help
	
	--dry-run		Import APIs, run checks, and do nothing and exit. Can be ran without root.

"""
	exit 0
}

#get flags
while [ "$#" -gt 0 ]
do
    case "${1}" in
        -D|--device) 
			DISKDEVICE=${2}
			shift 2
        ;;
        
        -p|--platform) 
			PLATFORM=${2}
			shift 2
        ;;
        
        -P|--profile) 
			PROFILE=${2}
			shift 2
        ;;
        
        -C|--cache) 
			DLCACHE="True"
			shift
        ;;
        
        -I|--image) 
			IMGBUILD="True"
			shift
        ;;
        
        -T|--tmp)
			OUTPUTTMP="True"
			shift
		;;
		
		--dry-run)
			DRYRUN="True"
			shift
		;;
		
		--debug)
			DEBUGMSG="True"
			shift
		;;
        
        -h|--help|?) 
			help-msg
			exit 0
        ;;
        
        -*)
            echo "Error: unknown argument \"${1}\""
            exit 1
        ;;
        
        *)
            shift
        ;;
    esac
done

#check if device is set
if [[ -z ${DISKDEVICE} ]]
then
	echo "Error: DISKDEVICE is not set"
    exit 1
fi

#check if we should find first available loop
if [[ ${DISKDEVICE} == "find" ]]
then
	DISKDEVICE=$(losetup -f)
fi

#Check if specified disk exists
check-if-exists "${DISKDEVICE}"
sync

#check whether to not clean up the workdir and use cached downloads
if [[ -z ${DLCACHE} ]]
then
	DLCACHE="False"
fi

#check whether to mount the output folder as tmpfs
if [[ -z ${OUTPUTTMP} ]]
then
	OUTPUTTMP="False"
fi

#dry run
if [[ -z ${DRYRUN} ]]
then
	DRYRUN="False"
fi

#debug messages
if [[ -z ${DEBUGMSG} ]]
then
	DEBUGMSG"False"
fi

#check whether to build an image
if [[ -z ${IMGBUILD} ]]
then
	IMGBUILD="False"
	
	#are you sure?
	read -p "THIS WILL WIPE ALL DATA ON ${DISKDEVICE} and install Arch Linux ARM on it. do you want to proceed? [y/N]: " CONTINUE
	if [[ ${CONTINUE} != [Yy]* ]]
	then
		echo "Abort!"
		exit 100
	fi	
fi

echo "continuing.."

sleep 0.5

#set partuuids for rest of installer
set-partuuids

#check if diskdevice is mmc or nvme and set partitions
check-nvme-mmc "${DISKDEVICE}"
