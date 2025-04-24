#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

Debug=4

source "$(pwd)/api/debugerr.sh"

source "$(pwd)/config/installer/paths.sh"

mkdir -p "${WORKDIR_TRANSIENT_PATH}"
mkdir -p "${WORKDIR_DISKFS_PATH}"

source "${API_PATH}/yaml.sh"
source "${API_PATH}/disk.sh"
