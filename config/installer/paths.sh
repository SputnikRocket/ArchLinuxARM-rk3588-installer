#!/bin/env bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#Installer root path
INSTALLER_ROOT="$(pwd)"

#Installer api path
API_PATH="${INSTALLER_ROOT}/api"

#Installer configuration paths
CONFIG_PATH="${INSTALLER_ROOT}/config"
CONFIG_INSTALLER_PATH="${CONFIG_PATH}/installer"
CONFIG_PLATFORM_PATH="${CONFIG_PATH}/platforms"
CONFIG_PROFILE_PATH="${CONFIG_PATH}/profiles"
CONFIG_USER_PATH="${CONFIG_PATH}/users"
CONFIG_BOOTLOADER_PATH="${CONFIG_PATH}/bootloaders"
CONFIG_DISKLAYOUT_PATH="${CONFIG_PATH}/disklayouts"

#Installer working directory paths
WORKDIR_PATH="${INSTALLER_ROOT}/work"
WORKDIR_DISKFS_PATH="${WORKDIR_PATH}/diskfs"
WORKDIR_ROOTFS_PATH="${WORKDIR_PATH}/rootfs"
WORKDIR_TMP_PATH="${WORKDIR_PATH}/tmp"
WORKDIR_DOWNLOAD_PATH="${WORKDIR_TMP_PATH}/download"
WORKDIR_TRANSIENT_PATH="${WORKDIR_TMP_PATH}/transient"
