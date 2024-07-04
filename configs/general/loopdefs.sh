#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#image filename settings
IMAGEFILE="${DISTRO}-${PLATFORM}-${PROFILE}-uefi.img"
