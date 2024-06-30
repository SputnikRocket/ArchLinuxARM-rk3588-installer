#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#enable a systemd service
function systemd-enable() {
	
	local WORKDIR=${1}
	local UNIT=${2}
	
	debug-output "Enabling ${UNIT} ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/systemctl enable ${UNIT}
}

#disable a systemd service
function systemd-disable() {
	
	local WORKDIR=${1}
	local UNIT=${2}
	
	debug-output "Disabling ${UNIT} ..."
	chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/systemctl disable ${UNIT}
}

#enable systemd services from list
function systemd-enable-list() {
	
	local WORKDIR=${1}
	local SERVICELIST=${2}
	
	debug-output "Enabling services specified in ${SERVICELIST} ..."
	xargs chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/systemctl enable < ${SERVICELIST}
}

#disable systemd services from list
function systemd-disable-list() {
	
	local WORKDIR=${1}
	local SERVICELIST=${2}
	
	debug-output "Disabling services specified in ${SERVICELIST} ..."
	xargs chroot ${WORKDIR}/${ROOTFSDIR} ${CHROOT_EXEC} /bin/systemctl disable < ${SERVICELIST}
}
