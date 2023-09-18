#!/bin/bash

#Installer variables get se here.
#Unless you know what you are doing, DO NOT modify these.

#Working directory stuff
WORKDIR="workdir"
ROOTFSDIR="root"
BOOTFSDIR="boot"
NEWBOOTFSDIR="root/boot"
DLTMP="download-tmp"

#Rootfs
ROOTFS_URL="http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz"
ROOTFS_TARBALL="ArchLinuxARM-aarch64-latest.tar.gz"

#Grub efi directory: DO NOT CHANGE THIS.
EFIDIR="boot"

#platform devicetrees
DTB_OPI5PLUS="dtbs/rockchip/rk3588-orangepi-5-plus.dtb"
DTB_ROCK5B="dtbs/rockchip/rk3588-rock-5b.dtb"
DTB_OPI5="dtbs/rockchip/rk3588s-orangepi-5.dtb"
DTB_OPI5B="dtbs/rockchip/rk3588s-orangepi-5b.dtb"
DTB_KHADAS_E2="dtbs/rockchip/rk3588s-khadas-edge2.dtb"
DTB_ROCK5A="dtbs/rockchip/rk3588s-rock-5a.dtb"
DTB_NANOPI_R6C="dtbs/rockchip/rk3588s-nanopi-r6c.dtb"
DTB_NANOPI_R6S="dtbs/rockchip/rk3588s-nanopi-r6s.dtb"
DTB_NANOPC_T6="dtbs/rockchip/rk3588-nanopc-t6.dtb"
DTB_BLADE3="dtbs/rockchip/rk3588-blade3-v101-linux.dtb"
DTB_IDNOVA="dtbs/rockchip/rk3588s-9tripod-linux.dtb"

#image filename prefixes
IMGPREFIX="ArchLinuxARM"
OUTDIR="outputs"
