#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#image file settings
IMG_PREFIX="ArtixLinuxARM"

#init to use
INIT_SYS="runit"

