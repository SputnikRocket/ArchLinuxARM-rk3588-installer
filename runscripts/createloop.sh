#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#create and mount loop
if [ ${SHALLOW} = "False" ]
then
	create-img
	
elif [ ${SHALLOW} = "True" ]
then 	
	check-if-exists "${OUTDIR}/${IMGPREFIX}-Generic_RK3588-${PROFILE}-UEFI.img"
	cp-image

fi
sync

attach-loop ${DISKDEVICE}
sync
