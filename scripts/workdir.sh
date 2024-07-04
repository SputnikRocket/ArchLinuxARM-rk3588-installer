#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#setup working directory
function setup-workdir() {

	local WORKDIR=${1}
    
    debug-output "Creating working directories ..."
    if [[ ! -e "${WORKDIR}/${ROOTFSDIR}" ]]
    then
		mkdir -p "${WORKDIR}/${ROOTFSDIR}"
    fi
    
    if [[ ! -e "${WORKDIR}/${BOOTFSDIR}" ]]
    then
		mkdir -p "${WORKDIR}/${BOOTFSDIR}"
	fi
	
	if [[ ! -e "${WORKDIR}/${DLTMP}" ]]
	then
		mkdir -p "${WORKDIR}/${DLTMP}"
	fi

	if [[ ! -e "${WORKDIR}/${PKGCACHEDIR}" ]]
    then
		mkdir -p "${WORKDIR}/${PKGCACHEDIR}"
    fi
    
    if [[ ! -e "${WORKDIR}/${TRANSIENTDIR}" ]]
    then
		mkdir -p "${WORKDIR}/${TRANSIENTDIR}"
    fi

	if [[ ! -e "${OUTDIR}" ]]
    then
		mkdir -p "${OUTDIR}"
    fi
    
    
}

#clean up working directory
function clean-workdir() {
	
	local WORKDIR=${1}
	
	debug-output "Removing working directories ..."
	rm -rf "${WORKDIR}"
}

#bind mount tmp download dir to workdir root
function mount-dltmp() {
	
	local WORKDIR=${1}
	
	debug-output "mounting temporary download directories to rootfs ..."
	mkdir -p "${WORKDIR}/${ROOTFSDIR}/${DLTMP}"
	mount -o bind "${WORKDIR}/${DLTMP}" "${WORKDIR}/${ROOTFSDIR}/${DLTMP}"	
	mount -o bind "${WORKDIR}/${PKGCACHEDIR}" "${WORKDIR}/${ROOTFSDIR}/var/cache/pacman/pkg"
}
