#!/bin/bash

#setup working directory
function setup-workdir() {

	local WORKDIR=${1}
    
	mkdir -p "${WORKDIR}/${ROOTFSDIR}"
	if [ "${?}" -ne "0" ]
	then
		echo "failed to create ${WORKDIR}/${ROOTFSDIR}!"
		return 1
	fi
    
	mkdir -p "${WORKDIR}/${BOOTFSDIR}"
	if [ "${?}" -ne "0" ]
	then
		echo "failed to create ${WORKDIR}/${BOOTFSDIR}!"
		return 1
	fi

	mkdir -p "${WORKDIR}/${DLTMP}"
	if [ "${?}" -ne "0" ]
	then
		echo "failed to create ${WORKDIR}/${DLTMP}!"
		return 1
	else
		return 0
	fi
}

#clean up working directory
function clean-workdir() {
	
	local WORKDIR=${1}
	rm -rf "${WORKDIR}"
	if [ "${?}" -ne "0" ]
	then
		echo "failed to clean ${WORKDIR}"
		return 1
	else
		return 0
	fi
}

#bind mount tmp download dir to workdir root
function mount-dltmp() {
	
	local WORKDIR=${1}
	
	mkdir -p "${WORKDIR}/${ROOTFSDIR}/${DLTMP}"
	if [ "${?}" -ne "0" ]
	then
		echo "failed to create ${WORKDIR}/${ROOTFSDIR}/${DLTMP}"
		return 1
	fi
    
	mount -o bind "${WORKDIR}/${DLTMP}" "${WORKDIR}/${ROOTFSDIR}/${DLTMP}"
	if [ "${?}" -ne "0" ]
	then
		echo "failed to mount ${WORKDIR}/${DLTMP} to ${WORKDIR}/${ROOTFSDIR}/${DLTMP}"
		return 1
	else
		return 0
	fi	
}
