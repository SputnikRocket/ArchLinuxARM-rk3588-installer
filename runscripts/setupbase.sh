#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#check for shallow build
if [ ${SHALLOW} = "False" ]
then
	#setup base system

	#unpack rootfs tarball
	unpack-rootfs "${WORKDIR}" "${WORKDIR}/${DLTMP}/${ROOTFS_TARBALL}"
	sync

fi

#remount boot
remount-bootfs "${WORKDIR}" "${DISKDEVICE}"
sync

#check for shallow build
if [ ${SHALLOW} = "False" ]
then
	#setup fses needed for chroot
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
	
	#add overlays
	add-overlay-profile-hook
	add-overlay-platform-hook
	
	#remove packages
	remove-pkgs-profile-hook
	remove-pkgs-platform-hook
	
	#add repos
	add-repos-profile-hook
	add-repos-platform-hook
	
	#install packages
	install-pkgs-profile-hook
	install-pkgs-platform-hook
	
	#enable services
	enable-services-profile-hook
	enable-services-platform-hook
	
	#disable services
	disable-services-profile-hook
	disable-services-platform-hook
	
	#bootlaoder setup
	bootloader-platform-hook

fi
sync

#check for shallow build
if [ ${SHALLOW} = "False" ]
then
	mkfstab "${WORKDIR}"
	
fi
sync
