#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#create and mount loop
create-img
sync

attach-loop ${DISKDEVICE}
sync
