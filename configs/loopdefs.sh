#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#import settings from platform and profile
image-defs-profile-hook
image-defs-platform-hook

#image filename settings
IMGPREFIX="ArchLinuxARM"
IMAGEFILE="${IMGPREFIX}-${IMGPLATFORMNAME}-${PROFILE}-UEFI.img"
