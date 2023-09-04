#!/bin/bash

#install grub
function install-grub() {
	
	local WORKDIR=${1}
	
	echo "installing grub to ${DISKPART1}..."
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" grub-install "${DISKPART1}" --efi-directory="/${EFIDIR}" --removable
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
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
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}

#generate main grub config
function mkconfig-grub() {
	
	local WORKDIR=${1}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" grub-mkconfig -o "/${EFIDIR}/grub/grub.cfg"
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}

#set ours as default menu entry
function set-grub-default() {
	
	local ENTRY=${1}
	
	echo "GRUB_DEFAULT=${ENTRY}" >> "${WORKDIR}/${ROOTFSDIR}/etc/default/grub"
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}
