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

	#install uefi to disk
	#get-file "${WORKDIR}" "${UEFI_URL}"
	#efi-install "${WORKDIR}" "${DISKDEVICE}" "${UEFI_FILE}"
	#sync 

	#make partitions
	mk-parts "${DISKDEVICE}"
	sync

	#hack to make mount not spam fstab change messages
	trap '' EXIT
	systemctl daemon-reload
	trap 'echo Error: in $0 on line $LINENO' ERR
	sync
	
fi
#mount disk to workdirs
mount-working-disks "${WORKDIR}" "${DISKDEVICE}"
sync
