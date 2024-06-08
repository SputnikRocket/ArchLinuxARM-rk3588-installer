#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#check whether requirements are met
if [ "$(id -u)" -ne 0 ]; then 
    echo "Please run as root"
    exit 1

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

