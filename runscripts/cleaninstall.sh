#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#clean up installation
pac-clean "${WORKDIR}"
sync

clean-configs "${WORKDIR}"
sync
