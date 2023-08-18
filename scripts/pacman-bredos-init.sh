#!/bin/bash

cd workdir/root/root/pkgs
wget https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/bredos-keyring-20230818-1-any.pkg.tar.xz
wget https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/bredos-mirrorlist-20230818-1-any.pkg.tar.xz
cd ../../../../

arch-chroot workdir/root /usr/bin/pacman -U "root/pkgs/bredos-keyring-20230818-1-any.pkg.tar.xz" --noconfirm
arch-chroot workdir/root /usr/bin/pacman -U "root/pkgs/bredos-mirrorlist-20230818-1-any.pkg.tar.xz" --noconfirm
arch-chroot workdir/root pacman -Sy --noconfirm



