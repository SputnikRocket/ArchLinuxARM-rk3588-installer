#!/bin/bash

mkdir -p workdir/root/boot/dtbs
cp -r workdir/root/usr/lib/linux-image-5.10.160-rockchip/rockchip workdir/root/boot/dtbs/
arch-chroot workdir/root mkinitcpio -p linux-rockchip-rk3588-jriek
