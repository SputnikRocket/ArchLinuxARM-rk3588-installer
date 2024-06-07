#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#setup disk partitioning

#check for shallow build
if [ ${SHALLOW} = "False" ]
then
	#regenerate gpt
	regen-gpt "${DISKDEVICE}"
	sync
 
	#make partitions
	mk-parts "${DISKDEVICE}"
	sync
	
fi
#mount disk to workdirs
mount-working-disks "${WORKDIR}" "${DISKDEVICE}"
sync
