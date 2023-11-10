#!/bin/bash

set -eE
trap 'echo Error: in $0 on line $LINENO' ERR

#remove disk image, compress and generate checksum
umount-dltmp "${WORKDIR}"
source runscripts/cleaninstall.sh
sync

unmount-workdirs "${WORKDIR}"
sync

clean-loop "${DISKDEVICE}"
sync

if [ ${DLCACHE} = "False" ]
then
	clean-workdir "${WORKDIR}"
fi
sync

compress-image
sync

gen-checksum
sync
