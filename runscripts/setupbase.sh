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

	#apply minimal overlay for multi-threaded downloads
	check-if-exists "${OVERLAYDIR}/overlay.minimal"

	apply-overlay "${WORKDIR}" "minimal"
	sync

	#initialize pacman
	pac-init "${WORKDIR}"
	sync

	#remove builtin kernel
	pac-remove "${WORKDIR}" "linux-aarch64"
	sync
	
	#apply profile config
	source runscripts/applyprofiles.sh
	sync

	#install grub
	install-grub "${WORKDIR}"
	sync

	mkconfig-grub "${WORKDIR}"
	sync

fi
sync

#check for shallow build
if [ ${SHALLOW} = "False" ]
then
	mkfstab "${WORKDIR}"
	
fi
sync
