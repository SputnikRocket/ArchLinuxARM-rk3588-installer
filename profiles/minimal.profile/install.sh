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

#do a pacman update for apparently no reason
pac-update "${WORKDIR}"
sync

#install necessary packages
pac-install-list "${WORKDIR}" "${PROFILEDIR}/${PROFILE}.profile/${PROFILE}.pkgs"
sync

#enable services for enabling usb 2 and resizing filesystem
systemd-enable "${WORKDIR}" "resize-filesystem.service"
systemd-enable "${WORKDIR}" "enable-usb2.service"
sync
