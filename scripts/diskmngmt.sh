#!/bin/bash

#format disks for install
function setup-disk() {

	local DISKDEVICE=${1}
    
	sync

	echo "Destroying partition table on ${DISKDEVICE}"
	sgdisk -Z "${DISKDEVICE}"
	if [ "${?}" -ne "0" ]
	then
		return 1
	fi
	sync

	echo "Creating new partition table on ${DISKDEVICE}"
	sgdisk -o "${DISKDEVICE}"
	if [ "${?}" -ne "0" ]
	then
		return 1
	fi
	sync

	echo "Creating partition of type 'EFI System Partition' on ${DISKDEVICE}1"
	sgdisk -n 1:+20M:+512M -t 1:ef00 -c 1:"ARCH_BOOT" "${DISKDEVICE}"
	if [ "${?}" -ne "0" ]
	then
		return 1
	fi
	sync

	echo "Creating partition of type 'Linux Filesystem' on ${DISKDEVICE}2"
	sgdisk -n 2:+4M:-20M -t 2:8300 -c 2:"ARCH_ROOT" "${DISKDEVICE}"
	if [ "${?}" -ne "0" ]
	then
		return 1
	fi
	sync

	echo "Formatting ${DISKDEVICE}1 as fat32"
	yes | mkfs.vfat -F 32 "${DISKDEVICE}1"
	if [ "${?}" -ne "0" ]
	then
		return 1
	fi
	sync

	echo "Formatting ${DISKDEVICE}2 as ext4"
	yes | mkfs.ext4 "${DISKDEVICE}2"
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		sync
		return 0
	fi
}

#mount disk to workdirs
function mount-working-disks() {
	
	local WORKDIR=${1}
	local DISKDEVICE=${2}
	
	echo "mounting installation device..."
	mount "${DISKDEVICE}1" "${WORKDIR}/${BOOTFSDIR}"
	if [ "${?}" -ne "0" ]
	then
		sync
		return 1
	fi
	sync
	
	mount "${DISKDEVICE}2" "${WORKDIR}/${ROOTFSDIR}"
	if [ "${?}" -ne "0" ]
	then
		sync
		return 1
	else
		sync
		return 0
	fi
}

#remount boot directory
function remount-bootfs() {
	
	local WORKDIR=${1}
	local DISKDEVICE=${2}
	
	echo "remounting bootfs..."
	umount -f "${DISKDEVICE}1"
	if [ "${?}" -ne "0" ]
	then
		sync
		return 1
	fi
	sync
	
	mount "${DISKDEVICE}1" "${WORKDIR}/${ROOTFSDIR}/${NEWBOOTFSDIR}"
	if [ "${?}" -ne "0" ]
	then
		sync
		return 1
	else
		sync
		return 0
	fi
}

#Unmount everything in wordir root
function unmount-workdirs() {
	
	local WORKDIR=${1}

	echo "unmounting installation..."
	sync
	umount -R -f "${WORKDIR}/${ROOTFSDIR}"
	if [ "${?}" -ne "0" ]
	then
		sync
		return 1
	else
		sync
		return 0
	fi
}