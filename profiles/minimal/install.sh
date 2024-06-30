#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#image file settings
IMGSIZE=4

#install and remove packages in these lists
PROFILE_PKGS_REMOVE="${PROFILEDIR}/${PROFILE}/pkgs.remove"
PROFILE_PKGS_INSTALL="${PROFILEDIR}/${PROFILE}/pkgs.install"

#enable and disable services in these lists
PROFILE_SERVICES_ENABLE="${PROFILEDIR}/${PROFILE}/services.enable"
PROFILE_SERVICES_DISABLE="${PROFILEDIR}/${PROFILE}/services.disable"

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
