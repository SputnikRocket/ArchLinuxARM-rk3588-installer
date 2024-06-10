#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#check if overlays exist before apply
check-if-exists "${OVERLAYDIR}/overlay.${PROFILE}"

#apply overlay
apply-overlay "${WORKDIR}" "${PROFILE}"
sync

# add kwankiu's pacman repo
pac-add-key "${WORKDIR}" "B669E3B56B3DC918"
pac-add-repo "${WORKDIR}" "[experimental]" "Server = https://github.com/kwankiu/PKGBUILDs/releases/download/experimental"
sync

# add 7Ji's pacman repo
pac-add-key "${WORKDIR}" "BA27F219383BB875"
pac-add-repo "${WORKDIR}" "[7Ji]" "Server = https://github.com/7Ji/archrepo/releases/download/$arch"
sync

#install necessary packages
pac-upgrade-list "${WORKDIR}" "${PROFILEDIR}/${PROFILE}.profile/${PROFILE}.pkgs"
sync

#enable and disable services
systemd-enable "${WORKDIR}" "resize-filesystem.service"
systemd-enable "${WORKDIR}" "enable-usb2.service"
systemd-enable "${WORKDIR}" "lightdm.service"
systemd-enable "${WORKDIR}" "NetworkManager.service"
systemd-disable "${WORKDIR}" "NetworkManager-wait-online.service"
systemd-enable "${WORKDIR}" "bluetooth.service" 
sync
