#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#pacman -Sy
function pac-update() {
	
	local WORKDIR=${1}
	
	debug-output "Updating repo package lists ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/pacman -Sy --noconfirm
}

#pacman-key --init & --populate
function pac-init() {
	
	local WORKDIR=${1}
	
	debug-output "Initializing pacman keyring ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/bash /bin/pacman-key --init
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/bash /bin/pacman-key --populate
}

#pacman -S 
function pac-install() {
	
	local WORKDIR=${1}
	local PACKAGE=${2}
	
	debug-output "Installing package ${PACKAGE} ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/pacman -S "${PACKAGE}"  --noconfirm --overwrite \* --disable-download-timeout
}

#pacman -U
function pac-install-local() {
	
	local WORKDIR=${1}
	local LOCALPKG=${2}
	
	debug-output "Installing local package /${DLTMP}/${LOCALPKG} ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/pacman -U --noconfirm --overwrite \* "/${DLTMP}/${LOCALPKG}"
}

#pacman -Rn 
function pac-remove() {
	
	local WORKDIR=${1}
	local PACKAGE=${2}
	
	debug-output "Removing package ${PACKAGE} ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/pacman -Rn "${PACKAGE}"  --noconfirm
}

#remove packages from list
function pac-remove-list() {
	
	local WORKDIR=${1}
	local PKGLIST=${2}
	
	debug-output "Removing packages specified in ${PKGLIST} ..."
	xargs chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/pacman -Rn --noconfirm < ${PKGLIST}
}

#pacman -Syyu
function pac-upgrade() {
	
	local WORKDIR=${1}
	
	debug-output "Fully upgrading installed packages ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/pacman -Syyu --noconfirm
}

#pacman -Scc
function pac-clean() {
	
	local WORKDIR=${1}
	
	debug-output "Cleaning pacman cache ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/pacman -Scc --noconfirm
	rm -rf ${WORKDIR}/${ROOTFSDIR}/var/cache/pacman/pkg/*
}

#pacman -Rdd
function pac-forceremove() {
	
	local WORKDIR=${1}
	local PACKAGE=${2}
	
	debug-output "Forcefully removing package ${PACKAGE} ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/pacman -Rdd "${PACKAGE}"  --noconfirm
}

#install packages from list
function pac-install-list() {
	
	local WORKDIR=${1}
	local PKGLIST=${2}
	
	debug-output "Installing packages specified in ${PKGLIST} ..."
	xargs chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/pacman -S --noconfirm < ${PKGLIST}
}

#install packages from list and upgrade at same time
function pac-upgrade-list() {
	
	local WORKDIR=${1}
	local PKGLIST=${2}
	
	debug-output "fully upgrading installed packages & installing packages specified in ${PKGLIST} ..."
	xargs chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/pacman -Syyu --noconfirm < ${PKGLIST}
}


# add pacman repo key
function pac-add-key() {
	
	local WORKDIR=${1}
	local PACKEY=${2}
	
	debug-output "Adding pacman key ${PACKEY}"
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/bash /bin/pacman-key --recv-keys "${PACKEY}"
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/bash /bin/pacman-key --lsign "${PACKEY}"
}

# add pacman repo
function pac-add-repo() {
	
	local WORKDIR=${1}
	local REPONAME=${2}
	local REPOURL=${3}
	
	debug-output "Adding repo ${REPONAME} ${REPOURL}"
	echo "" >> ${WORKDIR}/${ROOTFSDIR}/etc/pacman.conf
	echo "${REPONAME}" >> ${WORKDIR}/${ROOTFSDIR}/etc/pacman.conf
	echo "SigLevel = Never" >> ${WORKDIR}/${ROOTFSDIR}/etc/pacman.conf
	echo "${REPOURL}" >> ${WORKDIR}/${ROOTFSDIR}/etc/pacman.conf
}
