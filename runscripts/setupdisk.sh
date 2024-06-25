#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#setup disk partitioning

#regenerate gpt
regen-gpt "${DISKDEVICE}"
sync
 
#make partitions
mk-parts "${DISKDEVICE}"
sync

#mount disk to workdirs
mount-working-disks "${WORKDIR}" "${DISKDEVICE}"
sync
