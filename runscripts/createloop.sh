#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#check to mount output dir as tmpfs
if [[ ${OUTPUTTMP} == "True" ]]
then
	mount-tmp-output
	sync
fi

#create loop
create-img
sync

#mount loop
attach-loop ${DISKDEVICE}
sync
