#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

# Check Host arch and if qemu is needed
HOSTARCH=$(uname -m)
if [[ ${HOSTARCH} == "aarch64" ]]
then
	CHROOT_EXEC=""
	
else
	CHROOT_EXEC=qemu-aarch64-static

fi
