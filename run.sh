#/bin/bash

source configs/installerconfigs.sh
source configs/userconfigs.sh

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
if [[ ${CONTINUE} != [Yy]* ]]
then
	echo "Abort!"
	exit 100
fi
echo "continuing.."

#check if diskdevice is mmc or nvme and set partitions
check-nvme-mmc "${DISKDEVICE}"

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
get-file "${WORKDIR}" "${ROOTFS_URL}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 5
fi
sync

#unpack rootfs tarball
unpack-rootfs "${WORKDIR}" "${WORKDIR}/${DLTMP}/${ROOTFS_TARBALL}"
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
set-locale "${WORKDIR}" "${INSTALL_LOCALE}" "${INSTALL_LOCALE_ENC}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 8
fi
sync

#get required files
if [ "${SETUP_BREDOS}" = "yes" ]
then
	get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/bredos-keyring-20230818-1-any.pkg.tar.xz"
	if [ "${?}" -ne "0" ]
	then
		echo "ERROR! aborting..."
		exit 9
	fi
	sync

	get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/bredos-mirrorlist-20230818-1-any.pkg.tar.xz"
	if [ "${?}" -ne "0" ]
	then
		echo "ERROR! aborting..."
		exit 9
	fi
	sync

	get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/pacman-bredos-conf-1.0.0-1-aarch64.pkg.tar.xz"
	if [ "${?}" -ne "0" ]
	then
		echo "ERROR! aborting..."
		exit 9
	fi
	sync
fi
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/linux-image-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.zst"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 9
fi
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/linux-rockchip-rk3588-mkinitcpio-1.0.0-1-aarch64.pkg.tar.xz"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 9
fi
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/linux-dtbs-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.xz"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 9
fi
sync

#mount tmp downloads
mount-dltmp "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 10
fi
sync

#initialize pacman
pac-init "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 11
fi
sync

pac-update "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 11
fi
sync

#install bredos repo if specified
if [ "${SETUP_BREDOS}" = "yes" ]
then
	echo "installing BredOS repo"
	pac-install-local "${WORKDIR}" "bredos-keyring-20230818-1-any.pkg.tar.xz"
	if [ "${?}" -ne "0" ]
	then
		echo "ERROR! aborting..."
		exit 11
	fi
	sync

	pac-install-local "${WORKDIR}" "bredos-mirrorlist-20230818-1-any.pkg.tar.xz"
	if [ "${?}" -ne "0" ]
	then
		echo "ERROR! aborting..."
		exit 11
	fi
	sync

	pac-install-local "${WORKDIR}" "pacman-bredos-conf-1.0.0-1-aarch64.pkg.tar.xz"
	if [ "${?}" -ne "0" ]
	then
		echo "ERROR! aborting..."
		exit 11
	fi
	sync

	pac-update "${WORKDIR}"
	if [ "${?}" -ne "0" ]
	then
		echo "ERROR! aborting..."
		exit 11
	fi
	sync
else
	echo "Not installing BredOS repo"
fi
sync

#setup kernel
pac-remove "${WORKDIR}" "linux-aarch64"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 12
fi
sync

pac-install-local "${WORKDIR}" "linux-image-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.zst"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 12
fi
sync

pac-install-local "${WORKDIR}" "linux-rockchip-rk3588-mkinitcpio-1.0.0-1-aarch64.pkg.tar.xz"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 12
fi
sync

pac-install-local "${WORKDIR}" "linux-dtbs-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.xz"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 12
fi
sync

setup-mkinitcpio "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 12
fi
sync

#install grub
pac-install "${WORKDIR}" "grub"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 13
fi
sync

install-grub "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 13
fi
sync

grub-config-gen >> "${WORKDIR}/${ROOTFSDIR}/etc/grub.d/40_custom"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 13
fi
sync

set-grub-default "${GRUBENTRY}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 13
fi
sync


mkconfig-grub "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 13
fi
sync

umount-dltmp "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 13
fi
sync

mkfstab "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 13
fi
sync

#User code gets hooked here after system install
source scripts/usercode.sh

#wrap up
unmount-workdirs "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 14
fi
sync

clean-workdir "${WORKDIR}"
if [ "${?}" -ne "0" ]
then
	echo "ERROR! aborting..."
	exit 14
fi
sync

echo "success! you may now remove ${DISKDEVICE}"
exit 0




