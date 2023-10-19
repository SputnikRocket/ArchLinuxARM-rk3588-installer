#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#setup base system

#unpack rootfs tarball
unpack-rootfs "${WORKDIR}" "${WORKDIR}/${DLTMP}/${ROOTFS_TARBALL}"
sync

#remount boot
remount-bootfs "${WORKDIR}" "${DISKDEVICE}"
sync

#set locale
set-locale "${WORKDIR}" "${INSTALL_LOCALE}" "${INSTALL_LOCALE_ENC}"
sync

#mount tmp downloads
mount-dltmp "${WORKDIR}"
sync

#apply minimal overlay for multi-threaded downloads
check-if-exists "${OVERLAYDIR}/overlay.minimal"

apply-overlay "${WORKDIR}" "minimal"
sync

#initialize pacman
pac-init "${WORKDIR}"
sync

pac-update "${WORKDIR}"
sync

#setup kernel
pac-remove "${WORKDIR}" "linux-aarch64"
sync

pac-install-local "${WORKDIR}" "linux-image-5.10.160-rockchip-5.10.160-15-aarch64.pkg.tar.xz"
sync

#upgrade software
pac-upgrade "${WORKDIR}"
sync

#install extra software
pac-install "${WORKDIR}" "gptfdisk"
pac-install "${WORKDIR}" "parted"
sync

#install grub
pac-install "${WORKDIR}" "grub"
sync

install-grub "${WORKDIR}"
sync

mkconfig-grub "${WORKDIR}"
sync
if [[ "${DEVICETREE}" != "None" ]]
then
	insert-dtb-grub "${WORKDIR}"
fi
sync

mkfstab "${WORKDIR}"
sync
