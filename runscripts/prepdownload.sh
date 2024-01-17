#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#prepare workdir and download all required files

#setup workdirs
setup-workdir "${WORKDIR}"
sync

#get rootfs tarball
get-file "${WORKDIR}" "${ROOTFS_URL}"
sync


