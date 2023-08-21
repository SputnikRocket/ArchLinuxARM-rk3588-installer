#!/bin/bash

#install grub
function install-grub() {
	
	local WORKDIR=${1}
	local DISKDEVICE=${2}
	
	echo "installing grub to ${DISKDEVICE}1..."
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" grub-install "${DISKDEVICE}1" --efi-directory="/${NEWBOOTFSDIR}" --removable
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}
