#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#do a pacman update for apparently no reason
pac-update "${WORKDIR}"
sync

#enable services for enabling usb 2 and resizing filesystem
systemd-enable "${WORKDIR}" "resize-filesystem.service"
systemd-enable "${WORKDIR}" "enable-usb2.service"
sync
