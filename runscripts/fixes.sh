#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#apply fixes

#fix iwlwifi issue "ish"
mv ${WORKDIR}/${ROOTFSDIR}/lib/firmware/iwlwifi-ty-a0-gf-a0.pnvm ${WORKDIR}/${ROOTFSDIR}/lib/firmware/iwlwifi-ty-a0-gf-a0.pnvm.bak
sync
