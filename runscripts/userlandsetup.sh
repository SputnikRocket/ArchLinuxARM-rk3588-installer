#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#add overlays
add-overlay-profile-hook
add-overlay-platform-hook

#remove packages
merge-lists "${PROFPKGSREMOVE}" "${PLATPKGSREMOVE}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.remove"
pac-remove-list "${WORKDIR}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.remove"

#add repos
add-repos-profile-hook
add-repos-platform-hook

#install packages
merge-lists "${PROFPKGSINSTALL}" "${PLATPKGSINSTALL}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.install"
pac-upgrade-list "${WORKDIR}" "${WORKDIR}/${TRANSIENTDIR}/pkgs.install"

#enable services
enable-services-profile-hook
enable-services-platform-hook

#disable services
disable-services-profile-hook
disable-services-platform-hook
