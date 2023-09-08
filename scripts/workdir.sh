#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#setup working directory
function setup-workdir() {

	local WORKDIR=${1}
    
	mkdir -p "${WORKDIR}/${ROOTFSDIR}"
    
	mkdir -p "${WORKDIR}/${BOOTFSDIR}"

	mkdir -p "${WORKDIR}/${DLTMP}"
}

#clean up working directory
function clean-workdir() {
	
	local WORKDIR=${1}
	rm -rf "${WORKDIR}"
}

#bind mount tmp download dir to workdir root
function mount-dltmp() {
	
	local WORKDIR=${1}
	
	mkdir -p "${WORKDIR}/${ROOTFSDIR}/${DLTMP}"
    
	mount -o bind "${WORKDIR}/${DLTMP}" "${WORKDIR}/${ROOTFSDIR}/${DLTMP}"	
}
