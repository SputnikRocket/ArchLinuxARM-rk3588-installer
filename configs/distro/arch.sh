#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#Image file settings
IMG_PREFIX="ArchLinuxARM"

#Init to use
INIT_SYS="systemd"

#Rootfs
ROOTFS_URL="http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz"
ROOTFS_TARBALL="ArchLinuxARM-aarch64-latest.tar.gz"

#Hostname
INSTALL_HOSTNAME="alarm-uefi"
