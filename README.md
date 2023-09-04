# ArchLinuxARM-rk3588-installer
pile of scripts to aid in installation of arch linux arm on rk3588 hardware

requires [edk2-porting/edk2-rk3588](https://github.com/edk2-porting/edk2-rk3588) installed on SPI flash or sdcard to boot. preferably one of the latest actions builds.

# WARNING: THE CODE CONTAINED HERE IS A WORK IN PROGRESS. THESE SCRIPTS HAVE THE POTENTIAL TO DESTROY LOTS OF DATA. I AM NOT RESPONSIBLE FOR ANY DAMAGES DONE USING THIS SCRIPT. USE AT YOU OWN RISK.

requires:
gptfdisk,
aria2,
arch-chroot,
bsdtar,
active internet connection,
to be run as root(not sudo), 
and arm64 host

`<devname> refers to intire path of target install device, eg. /dev/sd*`

`# ./run.sh <devname>`

and enter "Y" when prompted

## PRs welcome
