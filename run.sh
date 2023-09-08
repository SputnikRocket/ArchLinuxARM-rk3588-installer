#/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

source configs/installerconfigs.sh
source configs/userconfigs.sh

source scripts/workdir.sh
source scripts/general.sh
source scripts/diskmngmt.sh
source scripts/pacman.sh
source scripts/grubsetup.sh

#Check if specified device exists
check-if-exists "${DISKDEVICE}"
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
sync

#setup disk
setup-disk "${DISKDEVICE}"
sync

#hack to make mount not spam fstab change messages
systemctl daemon-reload

#mount disk to workdirs
mount-working-disks "${WORKDIR}" "${DISKDEVICE}"
sync

#get rootfs tarball
get-file "${WORKDIR}" "${ROOTFS_URL}"
sync

#unpack rootfs tarball
unpack-rootfs "${WORKDIR}" "${WORKDIR}/${DLTMP}/${ROOTFS_TARBALL}"
sync

#remount boot
remount-bootfs "${WORKDIR}" "${DISKDEVICE}"
sync

#set locale
set-locale "${WORKDIR}" "${INSTALL_LOCALE}" "${INSTALL_LOCALE_ENC}"
sync

#get required files
if [ "${SETUP_BREDOS}" = "yes" ]
then
	get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/bredos-keyring-20230818-1-any.pkg.tar.xz"
	sync

	get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/bredos-mirrorlist-20230818-1-any.pkg.tar.xz"
	sync

	get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/pacman-bredos-conf-1.0.0-1-aarch64.pkg.tar.xz"
	sync
fi
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/linux-image-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.zst"
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/linux-rockchip-rk3588-mkinitcpio-1.0.0-1-aarch64.pkg.tar.xz"
sync

get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/linux-dtbs-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.xz"
sync

#mount tmp downloads
mount-dltmp "${WORKDIR}"
sync

#initialize pacman
pac-init "${WORKDIR}"
sync

pac-update "${WORKDIR}"
sync

#install bredos repo if specified
if [ "${SETUP_BREDOS}" = "yes" ]
then
	echo "installing BredOS repo"
	pac-install-local "${WORKDIR}" "bredos-keyring-20230818-1-any.pkg.tar.xz"
	sync

	pac-install-local "${WORKDIR}" "bredos-mirrorlist-20230818-1-any.pkg.tar.xz"
	sync

	pac-install-local "${WORKDIR}" "pacman-bredos-conf-1.0.0-1-aarch64.pkg.tar.xz"
	sync

	pac-update "${WORKDIR}"
	sync
else
	echo "Not installing BredOS repo"
fi
sync

#setup kernel
pac-remove "${WORKDIR}" "linux-aarch64"
sync

pac-install-local "${WORKDIR}" "linux-image-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.zst"
sync

pac-install-local "${WORKDIR}" "linux-rockchip-rk3588-mkinitcpio-1.0.0-1-aarch64.pkg.tar.xz"
sync

pac-install-local "${WORKDIR}" "linux-dtbs-5.10.160-rockchip-5.10.160-1-aarch64.pkg.tar.xz"
sync

setup-mkinitcpio "${WORKDIR}"
sync

#upgrade software
pac-upgrade "${WORKDIR}"
sync

#install grub
pac-install "${WORKDIR}" "grub"
sync

install-grub "${WORKDIR}"
sync

mkconfig-grub "${WORKDIR}"
sync

insert-dtb-grub "${WORKDIR}"
sync

umount-dltmp "${WORKDIR}"
sync

mkfstab "${WORKDIR}"
sync

#User code gets hooked here after system install
source scripts/usercode.sh

#clean up installation
pac-clean "${WORKDIR}"
sync

clean-configs "${WORKDIR}"
sync

#wrap up
unmount-workdirs "${WORKDIR}"
sync

clean-workdir "${WORKDIR}"
sync

echo "success! you may now remove ${DISKDEVICE}"
exit 0




