#!/bin/bash

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
	if [ "${?}" -ne "0" ]
	then
		echo "failed to change directory!"
		return 1
	fi
    
	wget -nv ${URL}
	if [ "${?}" -ne "0" ]
	then
		echo "failed to get file!"
		cd ../../
		return 1
	else
		cd ../../
		return 0
	fi
}

#unpack rootfs to wordir
function unpack-rootfs() {
	
	local WORKDIR=${1}
	local TARBALL=${2}
	
	echo "Extracting rootfs to ${WORKDIR}/${ROOTFSDIR}..."
	bsdtar -xpf "${TARBALL}" -C "${WORKDIR}/${ROOTFSDIR}"
	if [ "${?}" -ne "0" ]
	then
	    sync
		return 1
	fi
	sync

	echo "Moving boot files to ${WORKDIR}/${ROOTFSDIR}/${NEWBOOTFSDIR}"
	mv ${WORKDIR}/${ROOTFSDIR}/${NEWBOOTFSDIR}/* ${WORKDIR}/${BOOTFSDIR}/
	if [ "${?}" -ne "0" ]
	then
		sync
		return 1
	else
		sync
		return 0
	fi
}
	
#set locale
function set-locale() {
	
	local WORKDIR=${1}
	local SETLOCALE=${2}
	
	echo "setting installation locale..."
	echo "LANG=${SETLOCALE}" > "${WORKDIR}/${ROOTFSDIR}/etc/locale.conf"
	if [ "${?}" -ne "0" ]
	then
		return 1
	fi
	
	echo "${SETLOCALE} UTF-8" >> "${WORKDIR}/${ROOTFSDIR}/etc/locale.gen"
	if [ "${?}" -ne "0" ]
	then
		return 1
	fi
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" locale-gen
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi	
}

#mkinitcpio update
function setup-mkinitcpio() {
	
	local WORKDIR=${1}
	
	echo "generating initramfs..."
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" mkinitcpio -P
	if [ "${?}" -ne "0" ]
	then
		sync
		return 1
	else
		sync
		return 0
	fi	
}

#make fstab
function mkfstab() {
	
	local WORKDIR=${1}
	
	echo "generating fstab..."
	genfstab -U "${WORKDIR}/${ROOTFSDIR}" > "${WORKDIR}/${ROOTFSDIR}/etc/fstab"
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}
