#!/bin/bash

#pacman -Sy
function pac-update() {
	
	local WORKDIR=${1}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman -Sy --noconfirm
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}

#pacman-key --init & --populate archlinuxarm
function pac-init() {
	
	local WORKDIR=${1}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman-key --init
	if [ "${?}" -ne "0" ]
	then
		return 1
	fi
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman-key --populate archlinuxarm
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}

#pacman -S 
function pac-install() {
	
	local WORKDIR=${1}
	local PACKAGE=${2}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman -S "${PACKAGE}"  --noconfirm
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}

#pacman -U
function pac-install-local() {
	
	local WORKDIR=${1}
	local LOCALPKG=${2}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman -U --noconfirm --overwrite \* "/${DLTMP}/${LOCALPKG}"
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}

#pacman -Rn 
function pac-remove() {
	
	local WORKDIR=${1}
	local PACKAGE=${2}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman -Rn "${PACKAGE}"  --noconfirm
	if [ "${?}" -ne "0" ]
	then
		return 1
	else
		return 0
	fi
}


