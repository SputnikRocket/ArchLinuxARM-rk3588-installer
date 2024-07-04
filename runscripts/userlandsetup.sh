#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#add overlays
#check if overlay exists
check-if-exists "${PROFILEDIR}/${PROFILE}/overlay"
check-if-exists "${PLATFORMDIR}/${PLATFORM}/overlay"
	
#apply overlay is not empty
check-dir-empty "${PROFILEDIR}/${PROFILE}/overlay"
if [[ ${DIR_EMPTY} == "False" ]]
then
	apply-overlay "${WORKDIR}" "${PROFILEDIR}/${PROFILE}/overlay"
fi

#apply overlay is not empty
check-dir-empty "${PLATFORMDIR}/${PLATFORM}/overlay"
if [[ ${DIR_EMPTY} == "False" ]]
then
	apply-overlay "${WORKDIR}" "${PLATFORMDIR}/${PLATFORM}/overlay"
fi


#create custom pacman configurations
create-dir "${WORKDIR}" "etc/pacman.d/custom-conf"
insert-string "[options]" "${WORKDIR}/${ROOTFSDIR}/etc/pacman.conf"
insert-string "Include = /etc/pacman.d/custom-conf/general.conf" "${WORKDIR}/${ROOTFSDIR}/etc/pacman.conf"
insert-string "[options]" "${WORKDIR}/${ROOTFSDIR}/etc/pacman.d/custom-conf/general.conf"
insert-string "ParallelDownloads = 5" "${WORKDIR}/${ROOTFSDIR}/etc/pacman.d/custom-conf/general.conf"

#merge all lists for packages and services
merge-lists "${PROFILE_PKGS_REMOVE}" "${PLATFORM_PKGS_REMOVE}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.remove"
merge-lists "${PROFILE_PKGS_INSTALL}" "${PLATFORM_PKGS_INSTALL}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.install"
merge-lists "${PROFILE_SERVICES_ENABLE}" "${PLATFORM_SERVICES_ENABLE}" "${WORKDIR}/${TRANSIENTDIR}/services.enable"
merge-lists "${PROFILE_SERVICES_DISABLE}" "${PLATFORM_SERVICES_DISABLE}" "${WORKDIR}/${TRANSIENTDIR}/services.disable"

#remove packages if list is not empty
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
pac-upgrade-list "${WORKDIR}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.install"

#enable services if list is not empty
check-file-empty "${WORKDIR}/${TRANSIENTDIR}/services.enable"
if [[ ${FILE_EMPTY} == "False" ]]
then
	systemd-enable-list "${WORKDIR}" "${WORKDIR}/${TRANSIENTDIR}/services.enable"
fi

#disable services if list is not empty
check-file-empty "${WORKDIR}/${TRANSIENTDIR}/services.disable"
if [[ ${FILE_EMPTY} == "False" ]]
then
	systemd-disable-list "${WORKDIR}" "${WORKDIR}/${TRANSIENTDIR}/services.disable"
fi
