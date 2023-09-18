#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#make sure target loopdev is removed
function clean-loop() {
	
	local LOOPDEV=${1}
	
	losetup -d "${LOOPDEV}"
	sync
}

#create image file
function create-img() {
	
	sync
	
	touch "${OUTDIR}/${IMAGEFILE}"
	truncate --size $((8*1024*1024*1024)) ${OUTDIR}/${IMAGEFILE}
	dd if=/dev/zero of=${OUTDIR}/${IMAGEFILE} bs=512 count=16777216 status=progress
	sync
}

#attach image file to loop device
function attach-loop() {
	
	local LOOPDEV=${1}
	
	sync
	losetup --partscan "${LOOPDEV}" "${OUTDIR}/${IMAGEFILE}"
	partprobe "${LOOPDEV}"
	sync
}

#compress image
function compress-image() {
	
	sync
	xz -3 --force --keep --quiet --threads=0 "${OUTDIR}/${IMAGEFILE}"
	sync
}

#generate image checksum
function gen-checksum() {
	
	sync
	cd ${OUTDIR}
	sha256sum ${IMAGEFILE}.xz > ${IMAGEFILE}.xz.sha256
	cd ../
	sync
}
