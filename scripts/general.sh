#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#check if specified file exists or not
function check-if-exists() {

	local FILE=${1}
	if [ -e ${FILE} ]
	then
		echo "${FILE} exists!"
		return 0
	else
		echo "${FILE} does not exist!"
		return 1
	fi
}

#download a file to workdir
function get-file() {
	
	local WORKDIR=${1}
	local URL=${2}
	
	echo "getting file from ${URL}..."
	cd ${WORKDIR}/${DLTMP}
    
	aria2c ${URL}
	cd ../../
}

#unpack rootfs to wordir
function unpack-rootfs() {
	
	local WORKDIR=${1}
	local TARBALL=${2}
	
	echo "Extracting rootfs to ${WORKDIR}/${ROOTFSDIR}..."
	bsdtar -xpf "${TARBALL}" -C "${WORKDIR}/${ROOTFSDIR}"
	sync

	echo "Moving boot files to ${WORKDIR}/${NEWBOOTFSDIR}"
	mv ${WORKDIR}/${NEWBOOTFSDIR}/* ${WORKDIR}/${BOOTFSDIR}/
	sync
}
	
#set locale
function set-locale() {
	
	local WORKDIR=${1}
	local SETLOCALE=${2}
	local ENCODING=${3}
	
	echo "setting installation locale..."
	echo "LANG=${SETLOCALE}" > "${WORKDIR}/${ROOTFSDIR}/etc/locale.conf"
	
	echo "${SETLOCALE} ${ENCODING}" >> "${WORKDIR}/${ROOTFSDIR}/etc/locale.gen"
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" locale-gen
}

#mkinitcpio update
function setup-mkinitcpio() {
	
	local WORKDIR=${1}
	
	echo "generating initramfs..."
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" mkinitcpio -P	
}

#make fstab
function mkfstab() {
	
	local WORKDIR=${1}
	BOOTFSTABUUID=$(echo "${BOOTUUID^^}" | sed 's/./&-/4')
	ROOTFSTABUUID=${ROOTUUID,,}
	
	echo "generating fstab..."
	rm ${WORKDIR}/${ROOTFSDIR}/etc/fstab
	echo "# <file system>     <mount point>  <type>  <options>   <dump>  <fsck>" >>  ${WORKDIR}/${ROOTFSDIR}/etc/fstab
	echo "UUID=${BOOTFSTABUUID}	/boot	vfat	defaults	0	2" >> ${WORKDIR}/${ROOTFSDIR}/etc/fstab
	echo "UUID=${ROOTFSTABUUID}	/	ext4	defaults	0	1" >> ${WORKDIR}/${ROOTFSDIR}/etc/fstab
	echo "" >> ${WORKDIR}/${ROOTFSDIR}/etc/fstab
}

#clean possibly sensitive directories
function clean-configs() {
	
	local WORKDIR=${1}
	
	rm -rf ${WORKDIR}/${ROOTFSDIR}/etc/pacman.d/gnupg/*
	rm -rf ${WORKDIR}/${ROOTFSDIR}/etc/pacman.d/gnupg/.??*
	rm -rf ${WORKDIR}/${ROOTFSDIR}/var/log/pacman.log
	rm -rf ${WORKDIR}/${ROOTFSDIR}/var/lib/pacman/sync/*
	rm -rf ${WORKDIR}/${ROOTFSDIR}/${DLTMP}
}
