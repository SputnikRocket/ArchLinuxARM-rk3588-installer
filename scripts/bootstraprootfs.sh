#!/bin/bash

echo "Getting rootfs tarball"
wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz -O workdir/ArchLinuxARM-aarch64-latest.tar.gz

echo "syncing disks"
sync

echo "Extracting rootfs to workdir/root/"
bsdtar -xpf workdir/ArchLinuxARM-aarch64-latest.tar.gz -C workdir/root

echo "syncing disks"
sync

echo "Moving boot files to workdir/boot/"
mv workdir/root/boot/* workdir/boot/

echo "syncing disks"
sync

