#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

check-if-exists "${OVERLAYDIR}/overlay.${PROFILE}"

apply-overlay "${WORKDIR}" "${PROFILE}"
sync

pac-update "${WORKDIR}"
sync

systemd-enable "${WORKDIR}" "resize-filesystem.service"
systemd-enable "${WORKDIR}" "enable-usb2.service"
sync
