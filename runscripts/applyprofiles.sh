#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#apply profile
install-profile "${PROFILE}"
sync

source runscripts/fixes.sh
sync
