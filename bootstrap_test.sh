#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

Debug=4

source "$(pwd)/config/installer/paths.sh"

source "${API_PATH}/debugerr.sh"
source "${API_PATH}/yaml.sh"
source "${API_PATH}/presetup.sh"
source "${API_PATH}/disk.sh"

Create-Workdirs "${CONFIG_INSTALLER_PATH}/paths.sh"
