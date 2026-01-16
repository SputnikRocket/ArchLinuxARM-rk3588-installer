#!/bin/bash

set -eE
trap 'Print-Error " in api/paths.sh on line ${LINENO}"' ERR

# Installer root path
export INSTALLER_ROOT
INSTALLER_ROOT="$(pwd)"

# Installer api path
export API_PATH="${INSTALLER_ROOT}/api"

# Installer configuration paths
export CONFIG_PATH="${INSTALLER_ROOT}/config"
export CONFIG_INSTALLER_PATH="${CONFIG_PATH}/installer"
export CONFIG_PLATFORM_PATH="${CONFIG_PATH}/platforms"
export CONFIG_PROFILE_PATH="${CONFIG_PATH}/profiles"
export CONFIG_USER_PATH="${CONFIG_PATH}/users"
export CONFIG_BOOTLOADER_PATH="${CONFIG_PATH}/bootloaders"
export CONFIG_DISKLAYOUT_PATH="${CONFIG_PATH}/disklayouts"

# Installer working directory paths
export WORKDIR_PATH="${INSTALLER_ROOT}/work"
export WORKDIR_DISKFS_PATH="${WORKDIR_PATH}/diskfs"
export WORKDIR_ROOTFS_PATH="${WORKDIR_PATH}/rootfs"
export WORKDIR_TMP_PATH="${WORKDIR_PATH}/tmp"
export WORKDIR_DOWNLOAD_PATH="${WORKDIR_TMP_PATH}/download"
export WORKDIR_TRANSIENT_PATH="${WORKDIR_TMP_PATH}/transient"

# Image output path
export OUTPUT_PATH="${INSTALLER_ROOT}/outputs"
