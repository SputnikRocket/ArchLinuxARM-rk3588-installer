#!/bin/bash

arch-chroot workdir/root locale-gen
arch-chroot workdir/root pacman-key --init
arch-chroot workdir/root pacman-key --populate archlinuxarm
arch-chroot workdir/root pacman -Sy --noconfirm
