#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#install and remove packages in these lists
PLATFORM_PKGS_REMOVE="${PLATFORMDIR}/${PLATFORM}/packages/${DISTRO}/pkgs.remove"
PLATFORM_PKGS_INSTALL="${PLATFORMDIR}/${PLATFORM}/packages/${DISTRO}/pkgs.install"

#enable and disable services in these lists
PLATFORM_SERVICES_ENABLE="${PLATFORMDIR}/${PLATFORM}/services/${INIT_SYS}/services.enable"
PLATFORM_SERVICES_DISABLE="${PLATFORMDIR}/${PLATFORM}/services/${INIT_SYS}/services.disable"

#repos to add
function add-repos-platform-hook() {
	
	# add kwankiu's pacman repo
	pac-add-key "${WORKDIR}" "B669E3B56B3DC918"
	pac-add-repo "${WORKDIR}" "[rockchip]" "Server = https://github.com/kwankiu/PKGBUILDs/releases/download/\$arch"
	sync
}

#install bootloader
function bootloader-platform-hook() {
	
	#bootlaoder setup
	install-grub "${WORKDIR}"
	sync

	mkconfig-grub "${WORKDIR}"
	sync

	install-dtb "${WORKDIR}" "linux-aarch64-rockchip-bsp5.10-fydetab/rockchip/rk3588s-tablet-12c-linux.dtb"
	sync
}
