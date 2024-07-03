#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#image file settings
IMG_PREFIX="ArtixLinuxARM"

#init to use
INIT_SYS="runit"

#Rootfs
ROOTFS_URL="https://armtixlinux.org/images/armtix-runit-20240303.tar.xz"
ROOTFS_TARBALL="armtix-runit-20240303.tar.xz"

#Hostname
INSTALL_HOSTNAME="armtix-uefi"
