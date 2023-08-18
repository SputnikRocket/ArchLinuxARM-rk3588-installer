#!/bin/bash


arch-chroot workdir/root pacman -U "/root/pkgs/linux-image-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.zst" --noconfirm
arch-chroot workdir/root pacman -U "/root/pkgs/linux-headers-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.zst" --noconfirm


