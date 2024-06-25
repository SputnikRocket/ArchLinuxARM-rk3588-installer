#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

function image-defs-platform-hook() {
	
	IMGPLATFORMNAME="Generic_RK3588"
}

function add-overlay-platform-hook() {
	
	#check if overlays exist before apply
	check-if-exists "${PLATFORMDIR}/${PLATFORM}/overlay"
	
	#apply overlay
	apply-overlay "${WORKDIR}" "${PLATFORMDIR}/${PLATFORM}/overlay"
	sync
}

function remove-pkgs-platform-hook() {
	
	#remove packages
	pac-remove-list "${WORKDIR}" "${PLATFORMDIR}/${PLATFORM}/pkgs.remove"
	sync
}

function add-repos-platform-hook() {
	
	# add kwankiu's pacman repo
	pac-add-key "${WORKDIR}" "B669E3B56B3DC918"
	pac-add-repo "${WORKDIR}" "[rockchip]" "Server = https://github.com/kwankiu/PKGBUILDs/releases/download/\$arch"
	sync
}

function install-pkgs-platform-hook() {
	
	#install packages
	pac-upgrade-list "${WORKDIR}" "${PLATFORMDIR}/${PLATFORM}/pkgs.install"
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
