#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#image filename settings
IMGPREFIX="ArchLinuxARM"
IMAGEFILE="${IMGPREFIX}-${IMGPLATFORMNAME}-${PROFILE}-UEFI.img"
