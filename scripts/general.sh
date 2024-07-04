#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#debug messaging
function debug-output() {

	local OUTPUT=${1}
	local YELLOW="\e[33m"
	local GREEN="\e[32m"
	local ENDCOLOR="\e[0m"

	if [[ ${DEBUGMSG} == "True" ]]
	then
		echo -e "[${YELLOW}DEBUG${ENDCOLOR}] ${GREEN}${OUTPUT}${ENDCOLOR}"
	fi
}

#check if specified file exists or not
function check-if-exists() {

	local FILE=${1}

	if [ -e ${FILE} ]
	then
		debug-output "${FILE} exists!"
		return 0
	else
		debug-output "${FILE} does not exist!"
		return 1
	fi
}

#check if a file is empty
function check-file-empty() {

	local FILE=${1}

	if [[ -z $(grep '[^[:space:]]' ${FILE}) ]]
	then
		debug-output "${FILE} is empty"
		FILE_EMPTY="True"
	else
		debug-output "${FILE} is not empty"
		FILE_EMPTY="False"
	fi
}

#check if a directory is empty
function check-dir-empty() {

	local DIRECTORY=${1}

	if [[ -z $(ls "${DIRECTORY}/") ]]
	then
		debug-output "${FILE} is empty"
		DIR_EMPTY="True"
	else
		debug-output "${FILE} is not empty"
		DIR_EMPTY="False"
	fi
}

#download a file to workdir
function get-file() {
	
	local WORKDIR=${1}
	local URL=${2}
	
	debug-output "getting file from ${URL} ..."
	cd ${WORKDIR}/${DLTMP}
    
	aria2c -x 8 --auto-file-renaming=false --continue=true ${URL}
	cd ../../
}

#unpack rootfs to wordir
function unpack-rootfs() {
	
	local WORKDIR=${1}
	local TARBALL=${2}
	
	debug-output "Extracting rootfs to ${WORKDIR}/${ROOTFSDIR} ..."
	bsdtar -xpf "${TARBALL}" -C "${WORKDIR}/${ROOTFSDIR}"
	sync

	debug-output "Moving boot files to ${WORKDIR}/${NEWBOOTFSDIR} ..."
	mv ${WORKDIR}/${NEWBOOTFSDIR}/* ${WORKDIR}/${BOOTFSDIR}/
	sync
}
	
#set locale
function set-locale() {
	
	local WORKDIR=${1}
	local SETLOCALE=${2}
	local ENCODING=${3}
	
	debug-output "setting installation locale ..."
	echo "LANG=${SETLOCALE}" > "${WORKDIR}/${ROOTFSDIR}/etc/locale.conf"
	
	echo "${SETLOCALE} ${ENCODING}" >> "${WORKDIR}/${ROOTFSDIR}/etc/locale.gen"
	
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/bash /bin/locale-gen
}

#mkinitcpio update
function setup-mkinitcpio() {
	
	local WORKDIR=${1}
	
	debug-output "generating initramfs ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/bash /bin/mkinitcpio -P	
}

#make fstab
function mkfstab() {
	
	local WORKDIR=${1}
	BOOTFSTABUUID=$(echo "${BOOTUUID^^}" | sed 's/./&-/4')
	ROOTFSTABUUID=${ROOTUUID,,}
	
	debug-output "generating fstab ..."
	rm ${WORKDIR}/${ROOTFSDIR}/etc/fstab
	echo "# <file system>     <mount point>  <type>  <options>   <dump>  <fsck>" >>  ${WORKDIR}/${ROOTFSDIR}/etc/fstab
	echo "UUID=${BOOTFSTABUUID}	/boot	vfat	defaults	0	2" >> ${WORKDIR}/${ROOTFSDIR}/etc/fstab
	echo "UUID=${ROOTFSTABUUID}	/	ext4	defaults	0	1" >> ${WORKDIR}/${ROOTFSDIR}/etc/fstab
	echo "" >> ${WORKDIR}/${ROOTFSDIR}/etc/fstab
}

#clean possibly sensitive directories
function clean-configs() {
	
	local WORKDIR=${1}
	
	debug-output "Cleaning up install ..."
	rm -rf ${WORKDIR}/${ROOTFSDIR}/etc/pacman.d/gnupg/*
	rm -rf ${WORKDIR}/${ROOTFSDIR}/etc/pacman.d/gnupg/.??*
	rm -rf ${WORKDIR}/${ROOTFSDIR}/var/log/pacman.log
	rm -rf ${WORKDIR}/${ROOTFSDIR}/var/lib/pacman/sync/*
	rm -rf ${WORKDIR}/${ROOTFSDIR}/${DLTMP}
	rm -rf ${WORKDIR}/${NEWBOOTFSDIR}/grub/grub2.cfg
	rm -rf ${WORKDIR}/${ROOTFSDIR}/usr/bin/qemu-aarch64-static
}

#apply overlay
function apply-overlay() {
	
	local WORKDIR=${1}
	local OVERLAY=${2}
	
	debug-output "copying overlay ${OVERLAY} onto rootfs ..."
	cp -rf ${OVERLAY}/* ${WORKDIR}/${ROOTFSDIR}/
} 

#source config or runscript
function source-script() {
	
	local SRCSCRIPT=${1}
	
	debug-output "sourcing script ${SRCSCRIPT} ..."
	source ${SRCSCRIPT}
}

# copy host qemu to chroot
function install-qemu-chroot() {
	
	local WORKDIR=${1}
	local HOSTQEMU=$(which qemu-aarch64-static)
	
	debug-output "Copying host QEMU to rootfs ..."
	cp -rf ${HOSTQEMU} ${WORKDIR}/${ROOTFSDIR}/usr/bin/qemu-aarch64-static
}
	
# Set install hostname
function set-hostname() {

	local WORKDIR=${1}
	local SETHOSTNAME=${2}
	
	debug-output "Setting Hostname to ${SETHOSTNAME} ..."
	echo "${SETHOSTNAME}" > "${WORKDIR}/${ROOTFSDIR}/etc/hostname"
}

#mount output directory as tmpfs
function mount-tmp-output() {
	
	debug-output "Mounting output directory as tmpfs ..."
	mount -t tmpfs tmpfs ${OUTDIR}
}

#merge list files
function merge-lists() {
	
	local LISTFILE1=${1}
	local LISTFILE2=${2}
	local MERGEDFILE=${3}
	
	debug-output "Merging ${LISTFILE1} & ${LISTFILE2} into ${MERGEDFILE}"
	cat ${LISTFILE1} >> ${MERGEDFILE}
	cat ${LISTFILE2} >> ${MERGEDFILE}
}
