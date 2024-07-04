#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

# Check Host arch and if qemu is needed
HOSTARCH=$(uname -m)

if [[ ${HOSTARCH} == "aarch64" ]]
then
	CHROOT_EXEC=""
	debug-output "Host arch is ${HOSTARCH}, building native"
else
	CHROOT_EXEC="qemu-aarch64-static"
	debug-output "Host arch is ${HOSTARCH}, using QEMU usermode emulation"
fi

#check whether requirements are met
if [[ ${DRYRUN} == "False" ]]
then
	if [[ "$(id -u)" -ne 0 ]]
	then 
		echo "Please run as root"
		exit 1
	fi
fi

if [[ -z $(command -v mkfs.vfat) ]]
then
	echo "mkfs.vfat is missing, aborting"
	exit 1
fi

if [[ -z $(command -v mkfs.ext4) ]]
then
	echo "mkfs.ext4 is missing, aborting"
	exit 1
fi

if [[ -z $(command -v sgdisk) ]]
then
	echo "sgdisk is missing, aborting"
	exit 1
fi

if [[ -z $(command -v aria2c) ]]
then
	echo "aria2c is missing, aborting"
	exit 1
fi

if [[ -z $(command -v uuidgen) ]]
then
	echo "uuidgen is missing, aborting"
	exit 1
fi

if [[ -z $(command -v bsdtar) ]]
then
	echo "bsdtar is missing, aborting"
	exit 1	
fi

if [[ -z $(command -v partprobe) ]]
then
	echo "partprobe is missing, aborting"
	exit 1
fi

if [[ -z $(command -v xz) ]]
then
	echo "xz is missing, aborting"
	exit 1	
fi

if [[ ${HOSTARCH} == "aarch64" ]]
then	
	echo ""
else
	if [[ -z $(command -v qemu-aarch64-static) ]]
	then
		echo "qemu-aarch64-static is missing, aborting"
		exit 1	
	fi
fi
