#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#Installer variables get set here.
#Unless you know what you are doing, DO NOT modify these.

#Working directory stuff
WORKDIR="workdir"
ROOTFSDIR="root"
BOOTFSDIR="boot"
NEWBOOTFSDIR="root/boot"
DLTMP="download-tmp"
PKGCACHEDIR="pacman-pkg-cache"
PROFILEDIR="profiles"
PLATFORMDIR="platforms"
OUTDIR="outputs"
TRANSIENTDIR="installer-tmp"

#Grub efi directory: DO NOT CHANGE THIS.
EFIDIR="boot"
