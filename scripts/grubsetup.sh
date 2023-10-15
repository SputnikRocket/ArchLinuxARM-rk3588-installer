#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#install grub
function install-grub() {
	
	local WORKDIR=${1}
	
	echo "installing grub to ${DISKPART1}..."
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" grub-install "${DISKPART1}" --efi-directory="/${EFIDIR}" --removable
}

#generate main grub config
function mkconfig-grub() {
	
	local WORKDIR=${1}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" grub-mkconfig -o "/${EFIDIR}/grub/grub2.cfg"
}

#insert dtbs into /boot/grub/grub.cfg
function insert-dtb-grub() {
	
	local WORKDIR=${1}
	
	sed "/echo\	'Loading\ Linux/i \	devicetree\	\/${DEVICETREE}" ${WORKDIR}/${NEWBOOTFSDIR}/grub/grub2.cfg > ${WORKDIR}/${NEWBOOTFSDIR}/grub/grub.cfg
}
