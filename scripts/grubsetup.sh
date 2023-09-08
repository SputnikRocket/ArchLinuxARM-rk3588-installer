#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#install grub
function install-grub() {
	
	local WORKDIR=${1}
	
	echo "installing grub to ${DISKPART1}..."
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" grub-install "${DISKPART1}" --efi-directory="/${EFIDIR}" --removable
}

#Grub config generator
function grub-config-gen() {
	
	local BOOTUUID=$(blkid ${DISKPART1} -o export | grep UUID | sed "s/PARTUUID=[a-zA-Z|0-9|\-]*//g" | sed "s/\ //g" | sed '/^[[:space:]]*$/d' | sed "s/UUID=//g")
	local ROOTUUID=$(blkid ${DISKPART2} -o export | grep UUID | sed "s/PARTUUID=[a-zA-Z|0-9|\-]*//g" | sed "s/\ //g" | sed '/^[[:space:]]*$/d' | sed "s/UUID=//g")
	local KERNELPATH=$(ls /boot/vmlinu* | sed "s/\/boot\///g")
	local INITRAMFSPATH=$(ls /boot/initramfs* | sed "s/\/boot\///g")
	
	echo """menuentry 'Arch Linux ARM rk3588' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-${ROOTUUID}' {
	load_video
	set gfxpayload=keep
	insmod gzio
	insmod part_gpt
	insmod fat
	search --no-floppy --fs-uuid --set=root ${BOOTUUID}
	echo	'loading /${DEVICETREE} ...'
	devicetree	/${DEVICETREE}
	echo	'Loading Linux 5.10.160-rockchip ...'
	linux	/${KERNELPATH} root=UUID=${ROOTUUID} ${CMDLINE_EXTRA}
	echo	'Loading initial ramdisk ...'
	initrd	/${INITRAMFSPATH}
}
"""
}

#generate main grub config
function mkconfig-grub() {
	
	local WORKDIR=${1}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" grub-mkconfig -o "/${EFIDIR}/grub/grub2.cfg"
}

#set ours as default menu entry
function set-grub-default() {
	
	local WORKDIR=${1}
	local ENTRY=${2}
	
	echo "GRUB_DEFAULT=${ENTRY}" >> "${WORKDIR}/${ROOTFSDIR}/etc/default/grub"
}

#insert dtbs into /boot/grub/grub.cfg
function insert-dtb-grub() {
	
	local WORKDIR=${1}
	
	sed "/echo\	'Loading\ Linux/i \	devicetree\	\/${DEVICETREE}" ${WORKDIR}/${NEWBOOTFSDIR}/grub/grub2.cfg > ${WORKDIR}/${NEWBOOTFSDIR}/grub/grub.cfg
}
