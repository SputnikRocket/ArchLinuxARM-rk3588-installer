#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#regenerate gpt
function regen-gpt() {

	local DISKDEVICE=${1}
    
	sync

	echo "Destroying partition table on ${DISKDEVICE}"
	sgdisk -Z "${DISKDEVICE}"
	sync

	echo "Creating new partition table on ${DISKDEVICE}"
	sgdisk -o "${DISKDEVICE}"
	sync
}

#create partitions
function mk-parts() {
	
	local DISKDEVICE=${1}
	
	sync
	
	sgdisk -e "${DISKDEVICE}"
	sync
	
	echo "Creating partition of type 'EFI System Partition' on ${DISKPART1}"
	sgdisk -n 1:+20M:+512M -t 1:ef00 -c 1:"ARCH_BOOT" "${DISKDEVICE}"
	sync

	echo "Creating partition of type 'Linux Filesystem' on ${DISKPART2}"
	sgdisk -n 2:0:0 -t 2:8300 -c 2:"ARCH_ROOT" "${DISKDEVICE}"
	sync

	echo "Formatting ${DISKPART1} as fat32"
	yes | mkfs.vfat -i "${BOOTUUID}" -F 32 "${DISKPART1}"
	sync

	echo "Formatting ${DISKPART2} as ext4"
	yes | mkfs.ext4 -U "${ROOTUUID}" "${DISKPART2}"
	sync
}

#mount disk to workdirs
function mount-working-disks() {
	
	local WORKDIR=${1}
	local DISKDEVICE=${2}
	
	echo "mounting installation device..."
	mount "${DISKPART1}" "${WORKDIR}/${BOOTFSDIR}"
	sync
	
	mount "${DISKPART2}" "${WORKDIR}/${ROOTFSDIR}"
	sync
}

#remount boot directory
function remount-bootfs() {
	
	local WORKDIR=${1}
	local DISKDEVICE=${2}
	
	echo "remounting bootfs..."
	umount -f "${DISKPART1}"
	sync
	
	mount "${DISKPART1}" "${WORKDIR}/${NEWBOOTFSDIR}"
	sync
}

#unmount dltmp
function umount-dltmp() {
	
	local WORKDIR=${1}
	
	sync
	umount -f "${WORKDIR}/${ROOTFSDIR}/${DLTMP}"
	sync
}

#Unmount everything in wordir root
function unmount-workdirs() {
	
	local WORKDIR=${1}

	echo "unmounting installation..."
	sync
	umount -R -f "${WORKDIR}/${ROOTFSDIR}"
	sync
}

#checks if install disk is nvme, mmc, or loop
function check-nvme-mmc() {
	
	local DISKDEVICE=${1}
	
	if [[ "${DISKDEVICE}" = *"nvme"* ]] || [[ "${DISKDEVICE}" = *"mmc"* ]] || [[ "${DISKDEVICE}" = *"loop"* ]]
	then 
		DISKPART1="${DISKDEVICE}p1"
		DISKPART2="${DISKDEVICE}p2"
	else
		DISKPART1="${DISKDEVICE}1"
		DISKPART2="${DISKDEVICE}2"
	fi
}

#set UUIDS for partitions
function set-partuuids() {
	
	BOOTUUID=$(uuidgen | head -c8)
	ROOTUUID=$(uuidgen)
}
