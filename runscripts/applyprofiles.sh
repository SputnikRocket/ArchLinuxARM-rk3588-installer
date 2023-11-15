#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#check for shallow build
if [ ${SHALLOW} = "False" ]
then
	#apply profile
	install-profile "${PROFILE}"
	sync

	source runscripts/fixes.sh
fi

sync
