#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#setup base system

#unpack rootfs tarball
unpack-rootfs "${WORKDIR}" "${WORKDIR}/${DLTMP}/${ROOTFS_TARBALL}"
sync

#remount boot fs
remount-bootfs "${WORKDIR}" "${DISKDEVICE}"
sync

#setup temporary system fses needed for chroot
setup-chroot "${WORKDIR}"
sync
	
#copy qemu to chroot if not aarch64
if [[ ${HOSTARCH} == "aarch64" ]]
then
	echo ""	
else
	install-qemu-chroot "${WORKDIR}"	
fi

#set some settings
set-locale "${WORKDIR}" "${INSTALL_LOCALE}" "${INSTALL_LOCALE_ENC}"
set-hostname "${WORKDIR}" "${INSTALL_HOSTNAME}"
sync

#mount temporary directories
mount-dltmp "${WORKDIR}"
sync

#initialize pacman
pac-init "${WORKDIR}"
sync
	
#userland setup
source runscripts/userlandsetup.sh
	
#bootloader setup
source runscripts/bootloadersetup.sh

#make fstab
mkfstab "${WORKDIR}"
