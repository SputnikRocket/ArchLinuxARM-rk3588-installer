#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#make sure target loopdev is removed
function clean-loop() {
	
	local LOOPDEV=${1}
	
	debug-output "deregistering loop device ${LOOPDEV} ..."
	losetup -d "${LOOPDEV}"
	sync
}

#create image file
function create-img() {
	
	debug-output "Creating Image file ${OUTDIR}/${IMAGEFILE} ..."
	touch "${OUTDIR}/${IMAGEFILE}"
	truncate --size $((${IMGSIZE}*1024*1024*1024)) ${OUTDIR}/${IMAGEFILE}
	dd if=/dev/zero of=${OUTDIR}/${IMAGEFILE} bs=512 count=32768 status=progress
	truncate --size $((${IMGSIZE}*1024*1024*1024)) ${OUTDIR}/${IMAGEFILE}
	sync
}

#attach image file to loop device
function attach-loop() {
	
	local LOOPDEV=${1}
	
	debug-output "registering ${OUTDIR}/${IMAGEFILE} to loop device ${LOOPDEV} ..."
	losetup --partscan "${LOOPDEV}" "${OUTDIR}/${IMAGEFILE}"
	partprobe "${LOOPDEV}"
	sync
}

#compress image
function compress-image() {
	
	debug-output "Compressing ${OUTDIR}/${IMAGEFILE} with xz ..."
	xz -3 --force --keep --verbose --threads=0 "${OUTDIR}/${IMAGEFILE}"
	sync
}

#generate image checksum
function gen-checksum() {
	
	debug-output "Generating checksum for ${OUTDIR}/${IMAGEFILE}.xz ..."
	cd ${OUTDIR}
	sha256sum ${IMAGEFILE}.xz > ${IMAGEFILE}.xz.sha256
	cd ../
	sync
}

#copy generic image to non-generic-image
function cp-image() {
	
	cp -v -v ${OUTDIR}/${IMGPREFIX}-Generic_RK3588-${PROFILE}-UEFI.img ${OUTDIR}/${IMAGEFILE}
	sync
}
