#!/bin/bash

set -eE
trap 'echo Error: in $0 on line $LINENO' ERR

#configuration "chunks" to be used by each respective board

#Orange Pi 5 Plus
function config-orangepi-5plus {
	
	DEVICETREE="$DTB_OPI5PLUS"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5Plus-${PROFILE}-UEFI.img"
}

#Orange Pi 5
function config-orangepi-5 {
	
	DEVICETREE="$DTB_OPI5"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5-${PROFILE}-UEFI.img"
}

#Orange Pi 5B
function config-orangepi-5b {
	
	DEVICETREE="$DTB_OPI5B"
	IMAGEFILE="${IMGPREFIX}-OrangePi_5B-${PROFILE}-UEFI.img"
}

#Rock 5A
function config-rock-5a {
	
	DEVICETREE="$DTB_ROCK5A"
	IMAGEFILE="${IMGPREFIX}-Rock_5A-${PROFILE}-UEFI.img"
}

#Rock 5B
function config-rock-5b {
	
	DEVICETREE="$DTB_ROCK5B"
	IMAGEFILE="${IMGPREFIX}-Rock_5B-${PROFILE}-UEFI.img"
}

#Indiedroid Nova
function config-indiedroid-nova {
	
	DEVICETREE="$DTB_IDNOVA"
	IMAGEFILE="${IMGPREFIX}-Indiedroid_Nova-${PROFILE}-UEFI.img"
}

#NanoPi R6C
function config-nanopi-r6c {
	
	DEVICETREE="$DTB_NANOPI_R6C"
	IMAGEFILE="${IMGPREFIX}-NanoPi_R6C-${PROFILE}-UEFI.img"
}

#NanoPi R6S
function config-nanopi-r6s {
	
	DEVICETREE="$DTB_NANOPI_R6S"
	IMAGEFILE="${IMGPREFIX}-NanoPi_R6S-${PROFILE}-UEFI.img"
}

#NanoPC T6
function config-nanopc-t6 {
	
	DEVICETREE="$DTB_NANOPC_T6"
	IMAGEFILE="${IMGPREFIX}-NanoPC_T6-${PROFILE}-UEFI.img"
}

#Khadas Edge2
function config-khadas-edge2 {
	
	DEVICETREE="$DTB_KHADAS_E2"
	IMAGEFILE="${IMGPREFIX}-Khadas_Edge2-${PROFILE}-UEFI.img"
}

#Mixtile Blade3
function config-mixtile-blade3 {
	
	DEVICETREE="$DTB_BLADE3"
	IMAGEFILE="${IMGPREFIX}-Mixtile_Blade3-${PROFILE}-UEFI.img"
}


