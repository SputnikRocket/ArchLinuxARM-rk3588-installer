#!/bin/bash

echo "unmounting workdir/boot/"
umount workdir/boot

echo "syncing disks"
sync

echo "mounting ${1}1 to workdir/root/boot/"
mount "${1}1" workdir/root/boot

echo "syncing disks"
sync

