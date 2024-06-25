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

if [ ${DLCACHE} = "False" ]
then
	clean-workdir "${WORKDIR}"
fi
sync
