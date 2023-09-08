#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#pacman -Sy
function pac-update() {
	
	local WORKDIR=${1}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman -Sy --noconfirm
}

#pacman-key --init & --populate archlinuxarm
function pac-init() {
	
	local WORKDIR=${1}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman-key --init
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman-key --populate archlinuxarm
}

#pacman -S 
function pac-install() {
	
	local WORKDIR=${1}
	local PACKAGE=${2}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman -S "${PACKAGE}"  --noconfirm
}

#pacman -U
function pac-install-local() {
	
	local WORKDIR=${1}
	local LOCALPKG=${2}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman -U --noconfirm --overwrite \* "/${DLTMP}/${LOCALPKG}"
}

#pacman -Rn 
function pac-remove() {
	
	local WORKDIR=${1}
	local PACKAGE=${2}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman -Rn "${PACKAGE}"  --noconfirm
}

#pacman -Syyu
function pac-upgrade() {
	
	local WORKDIR=${1}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman -Syyu --noconfirm
}

#pacman -Scc
function pac-clean() {
	
	local WORKDIR=${1}
	
	arch-chroot "${WORKDIR}/${ROOTFSDIR}" pacman -Scc --noconfirm
	rm -rf ${WORKDIR}/${ROOTFSDIR}/var/cache/pacman/pkg/*
}


