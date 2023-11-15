#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#check for shallow build
if [ ${SHALLOW} = "False" ]
then
	#clean up installation
	pac-clean "${WORKDIR}"
	sync

fi
sync

#clean rootfs junk up
trap '' EXIT
clean-configs "${WORKDIR}"
trap 'echo Error: in $0 on line $LINENO' ERR

sync
