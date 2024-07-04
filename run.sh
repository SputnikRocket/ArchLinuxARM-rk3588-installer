#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

source configs/general/installerconfigs.sh

source scripts/workdir.sh
source scripts/general.sh
source scripts/diskmngmt.sh
source scripts/pacman.sh
source scripts/services.sh
source scripts/bootloader.sh
source scripts/loopdev.sh

source runscripts/inputhandler.sh
source runscripts/checkhost.sh
source runscripts/importconfscripts.sh

source configs/general/loopdefs.sh
source configs/general/userconfigs.sh

#check for dry run 
if [[ ${DRYRUN} == "True" ]]
then
	exit 0
fi

#prepare work and download files
source runscripts/prepdownload.sh

#if create loop is true, create and attach loop
if [[ ${IMGBUILD} = "True" ]]
then
	source runscripts/createloop.sh
fi

#setup disk
source runscripts/setupdisk.sh

#base installation
source runscripts/setupsystem.sh

#unmount disks and clean workdirs or wrap up loopdev
source runscripts/wrapupdisk.sh

exit 0
