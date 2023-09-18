#!/bin/bash

set -eE
trap 'echo Error: in $0 on line $LINENO' ERR

#remove disk image, compress and generate checksum
unmount-workdirs "${WORKDIR}"
sync

clean-loop "${DISKDEVICE}"
sync

clean-workdir "${WORKDIR}"
sync

compress-image
sync

gen-checksum
sync
