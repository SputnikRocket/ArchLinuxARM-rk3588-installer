#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#image filename settings
IMAGEFILE="${IMG_PREFIX}-${PLATFORM}-${PROFILE}-UEFI.img"
