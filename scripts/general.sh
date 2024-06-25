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
    
	aria2c -x 8 --auto-file-renaming=false --continue=true ${URL}
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
	
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/bash /bin/locale-gen
}

#mkinitcpio update
function setup-mkinitcpio() {
	
	local WORKDIR=${1}
	
	echo "generating initramfs..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/bash /bin/mkinitcpio -P	
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
	rm -rf ${WORKDIR}/${NEWBOOTFSDIR}/grub/grub2.cfg
	rm -rf ${WORKDIR}/${ROOTFSDIR}/usr/bin/qemu-aarch64-static
}

#enable a systemd service
function systemd-enable() {
	
	local WORKDIR=${1}
	local UNIT=${2}
	
	echo "enabling ${UNIT}"
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/systemctl enable ${UNIT}
}

#disable a systemd service
function systemd-disable() {
	
	local WORKDIR=${1}
	local UNIT=${2}
	
	echo "disabling ${UNIT}"
	sync
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/systemctl disable ${UNIT}
	sync
}

#apply overlay
function apply-overlay() {
	
	local WORKDIR=${1}
	local OVERLAY=${2}
	
	cp -rf ${OVERLAY}/* ${WORKDIR}/${ROOTFSDIR}/
} 

#install profile
function set-profile() {
	
	local PROFILE=${1}
	
	source ${PROFILEDIR}/${PROFILE}/install.sh
}

#install platform
function set-platform() {
	
	local PLATFORM=${1}
	
	source ${PLATFORMDIR}/${PLATFORM}/install.sh
}

# copy host qemu to chroot
function install-qemu-chroot() {
	
	local WORKDIR=${1}
	local HOSTQEMU=$(which qemu-aarch64-static)
	
	cp -rf ${HOSTQEMU} ${WORKDIR}/${ROOTFSDIR}/usr/bin/qemu-aarch64-static
}
	
# Set install hostname
function set-hostname() {

	local WORKDIR=${1}
	local SETHOSTNAME=${2}
	
	echo "Setting Hostname to ${SETHOSTNAME}"
	echo "${SETHOSTNAME}" > "${WORKDIR}/${ROOTFSDIR}/etc/hostname"
}

#mount output directory as tmpfs
function mount-tmp-output() {
	
	echo "Mounting output directory as tmpfs..."
	mount -t tmpfs tmpfs ${OUTDIR}
}
	
	
