#!/bin/bash

echo "Syncing disks"
sync

echo "Destroying partition table on ${1}"
sgdisk -Z "$1"
echo "Creating new partition table on ${1}"
sgdisk -o "$1"
echo "Creating partition of type 'EFI System Partition' on ${1}1"
sgdisk -n 1:+20M:+512M -t 1:ef00 -c 1:"ARCH_BOOT" "$1"
echo "Creating partition of type 'Linux Filesystem' on ${1}2"
sgdisk -n 2:+4M:-20M -t 2:8300 -c 2:"ARCH_ROOT" "$1"

echo "Syncing disks"
sync

echo "Formatting ${1}1 as fat32"
mkfs.vfat -F 32 "${1}1"
echo "Formatting ${1}2 as ext4"
mkfs.ext4 "${1}2"

echo "Syncing disks"
sync

