#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#setup disk partitioning

#setup disk
regen-gpt "${DISKDEVICE}"
sync

mk-parts "${DISKDEVICE}"
sync

#hack to make mount not spam fstab change messages
systemctl daemon-reload

#mount disk to workdirs
mount-working-disks "${WORKDIR}" "${DISKDEVICE}"
sync
