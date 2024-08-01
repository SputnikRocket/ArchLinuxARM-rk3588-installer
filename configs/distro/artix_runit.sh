#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#init to use
INIT_SYS="runit"

#Rootfs
ROOTFS_URL="https://armtix.artixlinux.org/images/armtix-runit-20240730.tar.xz"
ROOTFS_TARBALL="armtix-runit-20240730.tar.xz"

#Hostname
INSTALL_HOSTNAME="armtix-uefi"
