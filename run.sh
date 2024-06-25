#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

source configs/installerconfigs.sh

source scripts/workdir.sh
source scripts/general.sh
source scripts/diskmngmt.sh
source scripts/pacman.sh
source scripts/bootloader.sh
source scripts/loopdev.sh

source runscripts/inputhandler.sh
source runscripts/checkhost.sh
source runscripts/import-prof-plat.sh

source configs/loopdefs.sh
source configs/userconfigs.sh

#check for dry run 
if [[ ${DRYRUN} == "True" ]]
then
	exit 0
fi

#prepare work and download files
source runscripts/prepdownload.sh
sync

#if create loop is true, create and attach loop
if [[ ${IMGBUILD} = "True" ]]
then
	source runscripts/createloop.sh
fi
sync

#setup disk
source runscripts/setupdisk.sh
sync

#base installation
source runscripts/setupsystem.sh
sync

#unmount disks and clean workdirs or wrap up loopdev
if [[ ${IMGBUILD} == "True" ]]
then
	source runscripts/wrapuploop.sh
	
elif [[ ${IMGBUILD} == "False" ]]
then
	source runscripts/wrapupdisk.sh
fi
sync

echo "success! you may now remove ${DISKDEVICE}"
exit 0
