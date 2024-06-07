#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#install grub
function install-grub() {
	
	local WORKDIR=${1}
	
	echo "installing grub to ${DISKPART1}..."
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/grub-install "${DISKPART1}" \
	--efi-directory="/${EFIDIR}"                                    \
	--directory=/usr/lib/grub/arm64-efi/                            \
	--removable                                                     \
	--sbat /usr/share/grub/sbat.csv                                 \
	--modules="all_video boot btrfs cat chain configfile echo       \
	efifwsetup efinet ext2 fat font gettext gfxmenu gfxterm         \
	gfxterm_background gzio halt help hfsplus iso9660 jpeg          \ 
	keystatus loadenv loopback linux ls lsefi lsefimmap lsefisystab \
	lssal memdisk minicmd normal ntfs part_apple part_msdos         \
	part_gpt password_pbkdf2 png probe reboot regexp search         \
	search_fs_uuid search_fs_file search_label sleep smbios squash4 \
	test true video xfs zfs zfscrypt zfsinfo                        \
	cryptodisk gcry_arcfour gcry_blowfish gcry_camellia gcry_cast5  \
	gcry_crc gcry_des gcry_dsa gcry_idea gcry_md4 gcry_md5          \
	gcry_rfc2268 gcry_rijndael gcry_rmd160 gcry_rsa gcry_seed       \ 
	gcry_serpent gcry_sha1 gcry_sha256 gcry_sha512 gcry_tiger       \
	gcry_twofish gcry_whirlpool luks lvm mdraid09 mdraid1x raid5rec \
	raid6rec http tftp"
}

#generate main grub config
function mkconfig-grub() {
	
	local WORKDIR=${1}
	
	chroot ${WORKDIR}/${ROOTFSDIR} /bin/grub-mkconfig -o "/${EFIDIR}/grub/grub.cfg"
}
