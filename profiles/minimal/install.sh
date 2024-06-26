#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

IMGSIZE=4

PROFPKGSREMOVE="${PROFILEDIR}/${PROFILE}/pkgs.remove"
PROFPKGSINSTALL="${PROFILEDIR}/${PROFILE}/pkgs.install"

function add-overlay-profile-hook() {
	
	#check if overlays exist before apply
	check-if-exists "${PROFILEDIR}/${PROFILE}/overlay"
	
	#apply overlay
	apply-overlay "${WORKDIR}" "${PROFILEDIR}/${PROFILE}/overlay"
	sync
}

function add-repos-profile-hook() {
	echo ""
}

function enable-services-profile-hook() {
	
	#enable services
	systemd-enable "${WORKDIR}" "resize-filesystem.service"
	sync
}

function disable-services-profile-hook() {
	echo ""
}
