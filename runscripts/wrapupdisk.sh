#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#unmount and clean workdir

#wrap up
umount-dltmp "${WORKDIR}"
sync

source runscripts/cleaninstall.sh
sync

unmount-workdirs "${WORKDIR}"
sync

if [[ ${IMGBUILD} == "True" ]]
then
	clean-loop "${DISKDEVICE}"
	sync
fi

if [ ${DLCACHE} = "False" ]
then
	clean-workdir "${WORKDIR}"
	sync
fi

if [[ ${IMGBUILD} == "True" ]]
then
	compress-image
	sync

	gen-checksum
	sync
	
	echo "building of ${IMAGEFILE} finished."
else
	echo "success! you may now remove ${DISKDEVICE}"
fi
