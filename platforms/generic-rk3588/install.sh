#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#image file settings
IMGPLATFORMNAME="Generic_RK3588"

#install and remove packages in these lists
PLATFORM_PKGS_REMOVE="${PLATFORMDIR}/${PLATFORM}/pkgs.remove"
PLATFORM_PKGS_INSTALL="${PLATFORMDIR}/${PLATFORM}/pkgs.install"

#enable and disable services in these lists
PLATFORM_SERVICES_ENABLE="${PLATFORMDIR}/${PLATFORM}/services.enable"
PLATFORM_SERVICES_DISABLE="${PLATFORMDIR}/${PLATFORM}/services.disable"

function add-overlay-platform-hook() {
	
	#check if overlays exist before apply
	check-if-exists "${PLATFORMDIR}/${PLATFORM}/overlay"
	
	#apply overlay
	apply-overlay "${WORKDIR}" "${PLATFORMDIR}/${PLATFORM}/overlay"
	sync
}

function add-repos-platform-hook() {
	
	# add kwankiu's pacman repo
	pac-add-key "${WORKDIR}" "B669E3B56B3DC918"
	pac-add-repo "${WORKDIR}" "[rockchip]" "Server = https://github.com/kwankiu/PKGBUILDs/releases/download/\$arch"
	sync
}

function bootloader-platform-hook() {
	
	#bootlaoder setup
	install-grub "${WORKDIR}"
	sync

	mkconfig-grub "${WORKDIR}"
	sync
}
