#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

IMGPLATFORMNAME="Generic_RK3588"

PLATPKGSREMOVE="${PLATFORMDIR}/${PLATFORM}/pkgs.remove"
PLATPKGSINSTALL="${PLATFORMDIR}/${PLATFORM}/pkgs.install"

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

function enable-services-platform-hook() {
	
	#enable services
	systemd-enable "${WORKDIR}" "enable-usb2.service"
	sync
}

function disable-services-platform-hook() {
	echo ""
}

function bootloader-platform-hook() {
	
	#bootlaoder setup
	install-grub "${WORKDIR}"
	sync

	mkconfig-grub "${WORKDIR}"
	sync
}
