#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#install grub
function install-grub() {
	
	local WORKDIR=${1}
	
	echo "installing grub to ${DISKPART1}..."
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/grub-install "${DISKPART1}" --efi-directory="/${EFIDIR}" --removable
}

#generate main grub config
function mkconfig-grub() {
	
	local WORKDIR=${1}
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/grub-mkconfig -o "/${EFIDIR}/grub/grub.cfg"
}

#insert dtbs into /boot/grub/grub.cfg
function insert-dtb-grub() {
	
	local WORKDIR=${1}
	
	mv ${WORKDIR}/${NEWBOOTFSDIR}/grub/grub.cfg ${WORKDIR}/${NEWBOOTFSDIR}/grub/grub2.cfg
	sed "/echo\	'Loading\ Linux/i \	devicetree\	\/${DEVICETREE}" ${WORKDIR}/${NEWBOOTFSDIR}/grub/grub2.cfg > ${WORKDIR}/${NEWBOOTFSDIR}/grub/grub.cfg
}
