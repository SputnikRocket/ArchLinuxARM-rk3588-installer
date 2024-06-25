#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

function image-defs-profile-hook() {
	
	IMGSIZE=4
}

function add-overlay-profile-hook() {
	
	#check if overlays exist before apply
	check-if-exists "${PROFILEDIR}/${PROFILE}/overlay"
	
	#apply overlay
	apply-overlay "${WORKDIR}" "${PROFILEDIR}/${PROFILE}/overlay"
	sync
}

function remove-pkgs-profile-hook() {
	
	echo ""
	#remove packages
	#pac-remove-list "${WORKDIR}" "${PROFILEDIR}/${PROFILE}/pkgs.remove"
	#sync
}

function add-repos-profile-hook() {
	echo ""
}

function install-pkgs-profile-hook() {
	
	#install packages
	pac-upgrade-list "${WORKDIR}" "${PROFILEDIR}/${PROFILE}/pkgs.install"
	sync
}

function enable-services-profile-hook() {
	
	#enable services
	systemd-enable "${WORKDIR}" "resize-filesystem.service"
	sync
}

function disable-services-profile-hook() {
	echo ""
}
