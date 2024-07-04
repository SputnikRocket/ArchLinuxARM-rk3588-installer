#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#add overlays
add-overlay-profile-hook
add-overlay-platform-hook

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

