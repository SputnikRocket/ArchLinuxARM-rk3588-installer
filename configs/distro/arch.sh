#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#image file settings
IMG_PREFIX="ArchLinuxARM"

#init to use
INIT_SYS="systemd"

#Rootfs
ROOTFS_URL="http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz"
ROOTFS_TARBALL="ArchLinuxARM-aarch64-latest.tar.gz"
