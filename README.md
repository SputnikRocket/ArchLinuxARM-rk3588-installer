# ArchLinuxARM-rk3588-installer
pile of scripts to aid in installation of arch linux arm on rk3588 hardware

requires [edk2-porting/edk2-rk3588](https://github.com/edk2-porting/edk2-rk3588) installed on SPI flash or sdcard to boot. preferably one of the latest actions builds.

# WARNING: THE CODE CONTAINED HERE IS A WORK IN PROGRESS AND VERY MESSY. THESE SCRIPTS HAVE THE POTENTIAL TO DESTROY LOTS OF DATA AND ARE NOT GAURANTEED TO WORK. IM AM NOT RESPONSIBLE FOR ANY DAMAGES DONE USING THESE SCRIPTS. USE AT YOU OWN RISK AND STUPIDITY.

requires:
gptfdisk,
wget,
arch-chroot,
active internet connection,
And to be run as root

`<devname> refers to intire path of target install device, eg. /dev/sd*`

general script run secuence:

```
scripts/workdir-prepare.sh
scripts/sync.sh
scripts/mkdisk.sh <devname>
scripts/sync.sh
scripts/diskmount.sh <devname>
scripts/sync.sh
scripts/bootstraprootfs.sh
scripts/sync.sh
scripts/remountboot.sh <devname>
scripts/sync.sh
scripts/overlay-pre.sh
scripts/sync.sh
scripts/pacman-init.sh
scripts/sync.sh
scripts/pacman-bredos-init.sh
scripts/sync.sh
scripts/overlay-post.sh
scripts/sync.sh
scripts/pacman-remove-kernel.sh
scripts/sync.sh
scripts/get-kernel.sh
scripts/sync.sh
scripts/pacman-install-rk-kernel.sh
scripts/sync.sh
scripts/setup-kernel.sh
scripts/sync.sh
scripts/install-grub.sh <devname>
scripts/sync.sh
scripts/mkfstab.sh
scripts/sync.sh
scripts/done.sh
scripts/sync.sh
scripts/workdir-clean.sh
```
## PRs welcome
