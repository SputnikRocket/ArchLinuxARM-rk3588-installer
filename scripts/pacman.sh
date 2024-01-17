#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#pacman -Sy
function pac-update() {
	
	local WORKDIR=${1}
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/pacman -Sy --noconfirm
}

#pacman-key --init & --populate
function pac-init() {
	
	local WORKDIR=${1}
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/pacman-key --init
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/pacman-key --populate
}

#pacman -S 
function pac-install() {
	
	local WORKDIR=${1}
	local PACKAGE=${2}
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/pacman -S "${PACKAGE}"  --noconfirm --overwrite \* --disable-download-timeout
}

#pacman -U
function pac-install-local() {
	
	local WORKDIR=${1}
	local LOCALPKG=${2}
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/pacman -U --noconfirm --overwrite \* "/${DLTMP}/${LOCALPKG}"
}

#pacman -Rn 
function pac-remove() {
	
	local WORKDIR=${1}
	local PACKAGE=${2}
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/pacman -Rn "${PACKAGE}"  --noconfirm
}

#pacman -Syyu
function pac-upgrade() {
	
	local WORKDIR=${1}
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/pacman -Syyu --noconfirm
}

#pacman -Scc
function pac-clean() {
	
	local WORKDIR=${1}
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/pacman -Scc --noconfirm
	rm -rf ${WORKDIR}/${ROOTFSDIR}/var/cache/pacman/pkg/*
}

#pacman -Rdd
function pac-forceremove() {
	
	local WORKDIR=${1}
	local PACKAGE=${2}
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/pacman -Rdd "${PACKAGE}"  --noconfirm
}

#install packages from list
function pac-install-list() {
	
	local WORKDIR=${1}
	local PKGLIST=${2}
	
	xargs chroot ${WORKDIR}/${ROOTFSDIR} /bin/pacman -S --noconfirm < ${PKGLIST}
}
