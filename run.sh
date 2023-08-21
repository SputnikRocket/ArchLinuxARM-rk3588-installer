#/bin/bash

DISKDEVICE=${1}
WORKDIR=workdir
ROOTFSDIR=root
BOOTFSDIR=boot
NEWBOOTFSDIR=boot
DLTMP=download-tmp

source scripts/workdir.sh
source scripts/general.sh
source scripts/diskmngmt.sh
source scripts/pacman.sh
source scripts/grubsetup.sh

#Check if specified device exists
check-if-exists "${DISKDEVICE}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 1
fi
sync

#are you sure?
read -p "THIS WILL WIPE ALL DATA ON ${DISKDEVICE} and install Arch Linux ARM on it. do you want to proceed? [y/N]: " CONTINUE
if [ ${CONTINUE} = "Y" ]
then
	echo "continuing.."
else
	echo "Abort!"
	exit 100
fi

#setup workdirs
setup-workdir "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 2
fi
sync

#setup disk
setup-disk "${DISKDEVICE}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 3
fi
sync

#hack to make mount not spam fstab change messages
systemctl daemon-reload

#mount disk to workdirs
mount-working-disks "${WORKDIR}" "${DISKDEVICE}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 4
fi
sync

#get rootfs tarball
get-file "${WORKDIR}" "http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 5
fi
sync

#unpack rootfs tarball
unpack-rootfs "${WORKDIR}" "${WORKDIR}/${DLTMP}/ArchLinuxARM-aarch64-latest.tar.gz"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 6
fi
sync

#remount boot
remount-bootfs "${WORKDIR}" "${DISKDEVICE}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 7
fi
sync

#set locale
set-locale "${WORKDIR}" "en_US.UTF-8"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 8
fi
sync

#get required files
get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/bredos-keyring-20230818-1-any.pkg.tar.xz"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 9
fi
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/bredos-mirrorlist-20230818-1-any.pkg.tar.xz"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 9
fi
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/pacman-bredos-conf-1.0.0-1-aarch64.pkg.tar.xz"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 9
fi
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/linux-image-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.zst"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 9
fi
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/linux-rockchip-rk3588-mkinitcpio-1.0.0-1-aarch64.pkg.tar.xz"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 9
fi
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/linux-dtbs-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.xz"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 9
fi
sync

#mount tmp downloads
mount-dltmp "${WORKDIR}"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 10
fi
sync

#initialize pacman
pac-init "${WORKDIR}"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 11
fi
sync

pac-update "${WORKDIR}"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 11
fi
sync

pac-install-local "${WORKDIR}" "bredos-keyring-20230818-1-any.pkg.tar.xz"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 11
fi
sync

pac-install-local "${WORKDIR}" "bredos-mirrorlist-20230818-1-any.pkg.tar.xz"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 11
fi
sync

pac-install-local "${WORKDIR}" "pacman-bredos-conf-1.0.0-1-aarch64.pkg.tar.xz"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 11
fi
sync

pac-update "${WORKDIR}"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 11
fi
sync

#setup kernel
pac-remove "${WORKDIR}" "linux-aarch64"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 12
fi
sync

pac-install-local "${WORKDIR}" "linux-image-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.zst"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 12
fi
sync

pac-install-local "${WORKDIR}" "linux-rockchip-rk3588-mkinitcpio-1.0.0-1-aarch64.pkg.tar.xz"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 12
fi
sync

pac-install-local "${WORKDIR}" "linux-dtbs-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.xz"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 12
fi
sync

setup-mkinitcpio "${WORKDIR}"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 12
fi
sync

#install grub
pac-install "${WORKDIR}" "grub"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 13
fi
sync

install-grub "${WORKDIR}" "${DISKDEVICE}"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 13
fi
sync

mkfstab "${WORKDIR}"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 13
fi
sync

#wrap up
unmount-workdirs "${WORKDIR}"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 14
fi
sync

clean-workdir "${WORKDIR}"
 [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 14
fi
sync




