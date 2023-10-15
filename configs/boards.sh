#!/bin/bash

set -eE
trap 'echo Error: in $0 on line $LINENO' ERR

#configuration "chunks" to be used by each respective board

#Orange Pi 5 Plus
function config-orangepi-5plus {
	
	DEVICETREE="dtbs/rockchip/rk3588-orangepi-5-plus.dtb"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5Plus-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/orangepi-5plus_UEFI_Release_v0.9.1.img"
	UEFI_FILE="orangepi-5plus_UEFI_Release_v0.9.1.img"
}

#Orange Pi 5
function config-orangepi-5 {
	
	DEVICETREE="dtbs/rockchip/rk3588s-orangepi-5.dtb"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/orangepi-5_UEFI_Release_v0.9.1.img"
	UEFI_FILE="orangepi-5_UEFI_Release_v0.9.1.img"
}

#Orange Pi 5B
function config-orangepi-5b {
	
	DEVICETREE="dtbs/rockchip/rk3588s-orangepi-5b.dtb"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5B-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/orangepi-5_UEFI_Release_v0.9.1.img"
	UEFI_FILE="orangepi-5_UEFI_Release_v0.9.1.img"
}

#Rock 5A
function config-rock-5a {
	
	DEVICETREE="dtbs/rockchip/rk3588s-rock-5a.dtb"
	IMAGEFILE="${IMGPREFIX}-Rock_5A-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/rock-5a_UEFI_Release_v0.9.1.img"
	UEFI_FILE="rock-5a_UEFI_Release_v0.9.1.img"
}

#Rock 5B
function config-rock-5b {
	
	DEVICETREE="dtbs/rockchip/rk3588-rock-5b.dtb"
	IMAGEFILE="${IMGPREFIX}-Rock_5B-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/rock-5b_UEFI_Release_v0.9.1.img"
	UEFI_FILE="rock-5b_UEFI_Release_v0.9.1.img"
}

#Indiedroid Nova
function config-indiedroid-nova {
	
	DEVICETREE="dtbs/rockchip/rk3588s-9tripod-linux.dtb"
	IMAGEFILE="${IMGPREFIX}-Indiedroid_Nova-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/indiedroid-nova_UEFI_Release_v0.9.1.img"
	UEFI_FILE="indiedroid-nova_UEFI_Release_v0.9.1.img"
}

#NanoPi R6C
function config-nanopi-r6c {
	
	DEVICETREE="dtbs/rockchip/rk3588s-nanopi-r6c.dtb"
	IMAGEFILE="${IMGPREFIX}-NanoPi_R6C-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/nanopi-r6c_UEFI_Release_v0.9.1.img"
	UEFI_FILE="nanopi-r6c_UEFI_Release_v0.9.1.img"
}

#NanoPi R6S
function config-nanopi-r6s {
	
	DEVICETREE="dtbs/rockchip/rk3588s-nanopi-r6s.dtb"
	IMAGEFILE="${IMGPREFIX}-NanoPi_R6S-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/nanopi-r6s_UEFI_Release_v0.9.1.img"
	UEFI_FILE="nanopi-r6s_UEFI_Release_v0.9.1.img"
}

#NanoPC T6
function config-nanopc-t6 {
	
	DEVICETREE="dtbs/rockchip/rk3588-nanopc-t6.dtb"
	IMAGEFILE="${IMGPREFIX}-NanoPC_T6-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/nanopc-t6_UEFI_Release_v0.9.1.img"
	UEFI_FILE="nanopc-t6_UEFI_Release_v0.9.1.img"
}

#Khadas Edge2
function config-khadas-edge2 {
	
	DEVICETREE="dtbs/rockchip/rk3588s-khadas-edge2.dtb"
	IMAGEFILE="${IMGPREFIX}-Khadas_Edge2-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/edge2_UEFI_Release_v0.9.1.img"
	UEFI_FILE="edge2_UEFI_Release_v0.9.1.img"
}

#Mixtile Blade3
function config-mixtile-blade3 {
	
	DEVICETREE="dtbs/rockchip/rk3588-blade3-v101-linux.dtb"
	IMAGEFILE="${IMGPREFIX}-Mixtile_Blade3-${PROFILE}-UEFI.img"
	UEFI_URL="https://github.com/edk2-porting/edk2-rk3588/releases/download/v0.9.1/blade3_UEFI_Release_v0.9.1.img"
	UEFI_FILE="blade3_UEFI_Release_v0.9.1.img"
}

#None
function config-none() {
	
	DEVICETREE="None"
	IMAGEFILE="${IMGPREFIX}-Generic_RK3588-${PROFILE}-UEFI.img"
}
