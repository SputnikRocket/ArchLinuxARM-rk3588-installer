#!/bin/bash

set -eE
trap 'echo Error: in $0 on line $LINENO' ERR

#configuration "chunks" to be used by each respective board

#None
function config-none() {
	
	IMAGEFILE="${IMGPREFIX}-Generic_RK3588-${PROFILE}-UEFI.img"
}
