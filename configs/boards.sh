#!/bin/bash

set -eE
trap 'echo Error: in $0 on line $LINENO' ERR

#configuration "chunks" to be used by each respective board

#Orange Pi 5 Plus
function config-orangepi-5plus {
	
	DEVICETREE="dtbs/rockchip/rk3588-orangepi-5-plus.dtb"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5Plus-${PROFILE}-UEFI.img"

}

#Orange Pi 5
function config-orangepi-5 {
	
	DEVICETREE="dtbs/rockchip/rk3588s-orangepi-5.dtb"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5-${PROFILE}-UEFI.img"
}

#Orange Pi 5B
function config-orangepi-5b {
	
	DEVICETREE="dtbs/rockchip/rk3588s-orangepi-5b.dtb"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5B-${PROFILE}-UEFI.img"
}

#Rock 5A
function config-rock-5a {
	
	DEVICETREE="dtbs/rockchip/rk3588s-rock-5a.dtb"
	IMAGEFILE="${IMGPREFIX}-Rock_5A-${PROFILE}-UEFI.img"
}

#Rock 5B
function config-rock-5b {
	
	DEVICETREE="dtbs/rockchip/rk3588-rock-5b.dtb"
	IMAGEFILE="${IMGPREFIX}-Rock_5B-${PROFILE}-UEFI.img"
}

#Indiedroid Nova
function config-indiedroid-nova {
	
	DEVICETREE="dtbs/rockchip/rk3588s-9tripod-linux.dtb"
	IMAGEFILE="${IMGPREFIX}-Indiedroid_Nova-${PROFILE}-UEFI.img"
}

#NanoPi R6C
function config-nanopi-r6c {
	
	DEVICETREE="dtbs/rockchip/rk3588s-nanopi-r6c.dtb"
	IMAGEFILE="${IMGPREFIX}-NanoPi_R6C-${PROFILE}-UEFI.img"
}

#NanoPi R6S
function config-nanopi-r6s {
	
	DEVICETREE="dtbs/rockchip/rk3588s-nanopi-r6s.dtb"
	IMAGEFILE="${IMGPREFIX}-NanoPi_R6S-${PROFILE}-UEFI.img"
}

#NanoPC T6
function config-nanopc-t6 {
	
	DEVICETREE="dtbs/rockchip/rk3588-nanopc-t6.dtb"
	IMAGEFILE="${IMGPREFIX}-NanoPC_T6-${PROFILE}-UEFI.img"
}

#Khadas Edge2
function config-khadas-edge2 {
	
	DEVICETREE="dtbs/rockchip/rk3588s-khadas-edge2.dtb"
	IMAGEFILE="${IMGPREFIX}-Khadas_Edge2-${PROFILE}-UEFI.img"
}

#Mixtile Blade3
function config-mixtile-blade3 {
	
	DEVICETREE="dtbs/rockchip/rk3588-blade3-v101-linux.dtb"
	IMAGEFILE="${IMGPREFIX}-Mixtile_Blade3-${PROFILE}-UEFI.img"
}

#None
function config-none() {
	
	DEVICETREE="None"
	IMAGEFILE="${IMGPREFIX}-Generic_RK3588-${PROFILE}-UEFI.img"
}
