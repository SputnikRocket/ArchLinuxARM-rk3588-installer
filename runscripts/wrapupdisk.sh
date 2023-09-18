#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#unmount and clean workdir

#wrap up
unmount-workdirs "${WORKDIR}"
sync

clean-workdir "${WORKDIR}"
sync
