#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#add overlays
add-overlay-profile-hook
add-overlay-platform-hook

#create custom pacman configurations
create-dir "${WORKDIR}" "etc/pacman.d/custom-conf"

insert-string "[options]" "${WORKDIR}/${ROOTFSDIR}/etc/pacman.conf"
insert-string "Include = /etc/pacman.d/custom-conf/general.conf" "${WORKDIR}/${ROOTFSDIR}/etc/pacman.conf"

insert-string "[options]" "${WORKDIR}/${ROOTFSDIR}/etc/pacman.d/custom-conf/general.conf"
insert-string "ParallelDownloads = 5" "${WORKDIR}/${ROOTFSDIR}/etc/pacman.d/custom-conf/general.conf"

#remove packages
merge-lists "${PROFILE_PKGS_REMOVE}" "${PLATFORM_PKGS_REMOVE}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.remove"
check-file-empty "${WORKDIR}/${TRANSIENTDIR}/pkgs.remove"

if [[ ${FILE_EMPTY} == "False" ]]
then
	pac-remove-list "${WORKDIR}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.remove"
fi

#add repos
add-repos-profile-hook
add-repos-platform-hook

insert-string "Include = /etc/pacman.d/custom-conf/custom-repos.conf" "${WORKDIR}/${ROOTFSDIR}/etc/pacman.conf"

#install packages
merge-lists "${PROFILE_PKGS_INSTALL}" "${PLATFORM_PKGS_INSTALL}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.install"
pac-upgrade-list "${WORKDIR}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.install"

#enable services
merge-lists "${PROFILE_SERVICES_ENABLE}" "${PLATFORM_SERVICES_ENABLE}" "${WORKDIR}/${TRANSIENTDIR}/services.enable"
check-file-empty "${WORKDIR}/${TRANSIENTDIR}/services.enable"

if [[ ${FILE_EMPTY} == "False" ]]
then
	systemd-enable-list "${WORKDIR}" "${WORKDIR}/${TRANSIENTDIR}/services.enable"
fi

#disable services
merge-lists "${PROFILE_SERVICES_DISABLE}" "${PLATFORM_SERVICES_DISABLE}" "${WORKDIR}/${TRANSIENTDIR}/services.disable"
check-file-empty "${WORKDIR}/${TRANSIENTDIR}/services.disable"

if [[ ${FILE_EMPTY} == "False" ]]
then
	systemd-disable-list "${WORKDIR}" "${WORKDIR}/${TRANSIENTDIR}/services.disable"
fi

