#/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

source runscripts/checkarch.sh
source runscripts/checkdeps.sh

source configs/installerconfigs.sh
source configs/userconfigs.sh
source configs/boards.sh

source scripts/workdir.sh
source scripts/general.sh
source scripts/diskmngmt.sh
source scripts/pacman.sh
source scripts/grubsetup.sh
source scripts/loopdev.sh

source runscripts/inputhandler.sh

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
source runscripts/setupbase.sh
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




