#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#clean up pacman stuff
pac-clean "${WORKDIR}"
sync

#clean rootfs junk up
trap '' EXIT
clean-configs "${WORKDIR}"
trap 'echo Error: in $0 on line $LINENO' ERR
sync
