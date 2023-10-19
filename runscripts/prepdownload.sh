#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#prepare workdir and download all required files

#setup workdirs
setup-workdir "${WORKDIR}"
sync

#get rootfs tarball
get-file "${WORKDIR}" "${ROOTFS_URL}"
sync

#get required packages
get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/linux-image-5.10.160-rockchip-5.10.160-15-aarch64.pkg.tar.xz"
sync

