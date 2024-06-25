#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#check to mount output dir as tmpfs
if [[ ${OUTPUTTMP} == "True" ]]
then
	mount-tmp-output
	
fi
sync

#create and mount loop
if [ ${SHALLOW} = "False" ]
then
	
	image-defs-profile-hook
	image-defs-platform-hook
	
	IMAGEFILE="${IMGPREFIX}-${IMGPLATFORMNAME}-${PROFILE}-UEFI.img"
	
	create-img
	
elif [ ${SHALLOW} = "True" ]
then 	
	check-if-exists "${OUTDIR}/${IMGPREFIX}-Generic_RK3588-${PROFILE}-UEFI.img"
	cp-image

fi
sync

attach-loop ${DISKDEVICE}
sync
