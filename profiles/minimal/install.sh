#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#image file settings
IMGSIZE=4

#install and remove packages in these lists
PROFILE_PKGS_REMOVE="${PROFILEDIR}/${PROFILE}/packages/${DISTRO}/pkgs.remove"
PROFILE_PKGS_INSTALL="${PROFILEDIR}/${PROFILE}/packages/${DISTRO}/pkgs.install"

#enable and disable services in these lists
PROFILE_SERVICES_ENABLE="${PROFILEDIR}/${PROFILE}/services/${INIT_SYS}/services.enable"
PROFILE_SERVICES_DISABLE="${PROFILEDIR}/${PROFILE}/services/${INIT_SYS}/services.disable"

#repos to add
function add-repos-profile-hook() {
	echo ""
}
