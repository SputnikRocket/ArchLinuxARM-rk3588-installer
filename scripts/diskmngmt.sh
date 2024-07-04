#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#regenerate gpt
function regen-gpt() {

	local DISKDEVICE=${1}

	debug-output "Destroying partition table on ${DISKDEVICE} ..."
	sgdisk -Z "${DISKDEVICE}"
	sync

	debug-output "Creating new partition table on ${DISKDEVICE} ..."
	sgdisk -o "${DISKDEVICE}"
	sync
}

#create partitions
function mk-parts() {
	
	local DISKDEVICE=${1}
	
	sgdisk -e "${DISKDEVICE}"
	sync
	
	debug-output "Creating partition of type 'EFI System Partition' on ${DISKPART1} ..."
	sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"ARCH_BOOT" "${DISKDEVICE}"
	sync

	debug-output "Creating partition of type 'Linux Filesystem' on ${DISKPART2} ..."
	sgdisk -n 2:0:0 -t 2:8300 -c 2:"ARCH_ROOT" "${DISKDEVICE}"
	sync

	debug-output "Formatting ${DISKPART1} as fat32 ..."
	yes | mkfs.vfat -i "${BOOTUUID}" -F 32 "${DISKPART1}"
	sync

	debug-output "Formatting ${DISKPART2} as ext4 ..."
	yes | mkfs.ext4 -U "${ROOTUUID}" "${DISKPART2}"
	sync
}

#mount disk to workdirs
function mount-working-disks() {
	
	local WORKDIR=${1}
	local DISKDEVICE=${2}
	
	debug-output "mounting installation device ..."
	mount -o discard "${DISKPART1}" "${WORKDIR}/${BOOTFSDIR}"
	sync
	
	mount -o discard "${DISKPART2}" "${WORKDIR}/${ROOTFSDIR}"
	sync
}

#remount boot directory
function remount-bootfs() {
	
	local WORKDIR=${1}
	local DISKDEVICE=${2}
	
	debug-output "remounting bootfs ..."
	umount "${DISKPART1}"
	sync
	
	mount -o discard "${DISKPART1}" "${WORKDIR}/${NEWBOOTFSDIR}"
	sync
}

#unmount dltmp
function umount-dltmp() {
	
	local WORKDIR=${1}
	
	debug-output "unmounting temporary downloads dir from rootfs ..."
	umount "${WORKDIR}/${ROOTFSDIR}/${DLTMP}"
	sync
}

#Unmount everything in wordir root
function unmount-workdirs() {
	
	local WORKDIR=${1}

	debug-output "unmounting installation ..."
	fuser --mount "${WORKDIR}/${ROOTFSDIR}/dev" --kill
	umount --recursive "${WORKDIR}/${ROOTFSDIR}"
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
	
	debug-output "setting partition UUIDs ..."
	BOOTUUID=$(uuidgen | head -c8)
	ROOTUUID=$(uuidgen)
}

#mount filesystems needed for chroot
function setup-chroot() {
	
	local WORKDIR=${1}
	
	debug-output "Mounting temporary filesytems and copying files needed from host for chroot ..."
	mount -t proc /proc ${WORKDIR}/${ROOTFSDIR}/proc/
	sync
	mount -t sysfs /sys ${WORKDIR}/${ROOTFSDIR}/sys/
	sync
	mount --rbind /dev ${WORKDIR}/${ROOTFSDIR}/dev/
	sync
	mount --make-rslave ${WORKDIR}/${ROOTFSDIR}/dev/
	sync
	cp -f --remove-destination /etc/resolv.conf ${WORKDIR}/${ROOTFSDIR}/etc/resolv.conf
	sync
}	

