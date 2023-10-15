#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#update pacman lists
pac-update "${WORKDIR}"
sync

#get packages for bred OS mirror and hardware desktop accel
get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/bredos-keyring-20230818-1-any.pkg.tar.xz"
get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/bredos-mirrorlist-20230818-1-any.pkg.tar.xz"
get-file "${WORKDIR}" "https://github.com/SputnikRocket/archlinuxarm-rk3588-pkgs/releases/download/latest/mali-g610-firmware-1.0.2-1-any.pkg.tar.zst"
sync

#install bredOS stuff
pac-install-local "${WORKDIR}" "bredos-keyring-20230818-1-any.pkg.tar.xz"
pac-install-local "${WORKDIR}" "bredos-mirrorlist-20230818-1-any.pkg.tar.xz"
sync

#check if overlays exist before apply
check-if-exists "${OVERLAYDIR}/overlay.${PROFILE}"

#apply overlay
apply-overlay "${WORKDIR}" "${PROFILE}"
sync

#update again
pac-update "${WORKDIR}"
sync

#install necessary packages
pac-install "${WORKDIR}" "networkmanager"
pac-install "${WORKDIR}" "network-manager-applet"
pac-install "${WORKDIR}" "xfce4"
pac-install "${WORKDIR}" "xorg"
pac-install "${WORKDIR}" "lightdm"
pac-install "${WORKDIR}" "lightdm-gtk-greeter"
pac-install "${WORKDIR}" "lightdm-gtk-greeter-settings"
pac-install "${WORKDIR}" "xdg-user-dirs"
pac-install "${WORKDIR}" "firefox"
sync

#install panfork
pac-forceremove "${WORKDIR}" "mesa"
pac-install "${WORKDIR}" "mesa-panfork-git"
pac-install-local "${WORKDIR}" "mali-g610-firmware-1.0.2-1-any.pkg.tar.zst"
sync

#enable required services
systemd-enable "${WORKDIR}" "resize-filesystem.service"
systemd-enable "${WORKDIR}" "enable-usb2.service"
systemd-enable "${WORKDIR}" "lightdm.service"
systemd-enable "${WORKDIR}" "set-mali-firmware.service"
systemd-enable "${WORKDIR}" "NetworkManager.service"
sync
