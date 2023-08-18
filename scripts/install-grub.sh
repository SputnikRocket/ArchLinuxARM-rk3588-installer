#!/bin/bash

arch-chroot workdir/root pacman -S grub --noconfirm
arch-chroot workdir/root grub-install ${1}1 --efi-directory=/boot --removable
