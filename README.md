# ArchLinuxARM-rk3588-installer

[![Total Github Downloads](https://img.shields.io/github/downloads/SputnikRocket/ArchLinuxARM-rk3588-installer/total.svg?&color=E95420&label=Total%20Downloads)](https://github.com/SputnikRocket/ArchLinuxARM-rk3588-installer/releases)

Arch Linux ARM for rk3588 SBCs, such as the Orange Pi 5(+,B), Indiedroid Nova, Radxa Rock 5(A,B), and others using edk2 UEFI.

requires [edk2-porting/edk2-rk3588](https://github.com/edk2-porting/edk2-rk3588) installed on SPI flash or an sdcard to boot.

## Installation Instructions
Installation Instructions can be found in the [Wiki](https://github.com/SputnikRocket/ArchLinuxARM-rk3588-installer/wiki).

## Notes:
- This project is very much a work in progress. therefore, there may be missing features, bugs, and lack of documentation for now.
- This builder may be used to build for other aarch64 UEFI platforms via contribution, but I will only support the "Generic RK3588" target.

## Contributing
here are some of the ways you can contribute to this project, to show appreciation for my work: 

* Starring this repo
* Following me on GitHub
* Opening issues for for adding features or fixing critical bugs
* Forking this repo and submitting code
* Sponsoring me on github, any amount is greatly appreciated, thank you!

### Credits:
* @kwankiu for rk3588 kernel packages in his [repo](https://github.com/kwankiu/PKGBUILDs)
* @Joshua-Riek and the [ubuntu-rockchip](https://github.com/Joshua-Riek/ubuntu-rockchip) project for some files in [overlays](https://github.com/SputnikRocket/ArchLinuxARM-rk3588-installer/tree/main/overlays)
* @mariobalanica and all those part of the [edk2-rk3588](https://github.com/edk2-porting/edk2-rk3588) project, for making this possible
