#!/bin/bash

set -eE
trap 'Print-Error " in api/disk.sh on line ${LINENO}"' ERR


# Wipe disk & create partitions
function Setup-Disk () {
	
	local DiskDevice=${1}
	local ConfigYaml=${2}
	local GuestFstab=${3}
	local MountTab=${4}
	
	
	# Get list of partitions
	Yaml-Element-GetSubLists "${ConfigYaml}" ".partitions"
	local PartList="${YamlOutput}"
	
	
	# Check if specified file is block device
	Print-Debug "Checking if specified disk is block device..." 1
	if [[ $(stat --format=%F "${DiskDevice}") == "block special file" ]]
	then
		Print-Debug "Block Device Check succeeded" 2
	else
		Print-Debug "Specified disk is not a block device! quitting..." 2
		exit 1
	fi
	
	
	# Check whether to add a "p" between device name and partition number 
	if [[ "${DiskDevice}" == *"nvme"* ]] || [[ "${DiskDevice}" == *"mmc"* ]] || [[ "${DiskDevice}" == *"loop"* ]]
	then
		local PartSeparator="p"
	
	else
		local PartSeparator=""
		
	fi
	
	
	# Clear partition table on disk
	Print-Debug "Recreating GPT on ${DiskDevice}..."
	sgdisk -Z "${DiskDevice}"
	sgdisk -o "${DiskDevice}"
	sync
	
	
	# Recurse through partition list, creating each one
	for Part in ${PartList}
	do
		# Get basic partition details
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.partinfo.partnum"
		local PartNum="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.partinfo.label"
		local PartLabel="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.partinfo.type"
		local PartType="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.partinfo.offsets.start"
		local PartStart="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.partinfo.offsets.end"
		local PartEnd="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.fsinfo.type"
		local PartFsType="${YamlOutput}"
		
		# Get mount details
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.fsinfo.mountopts.path"
		local PartMountPath="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.fsinfo.mountopts.flags"
		local PartMountFlags="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.fsinfo.mountopts.backup"
		local PartMountBackup="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.fsinfo.mountopts.check"
		local PartMountCheck="${YamlOutput}"
		
		# Generate filesystem UUIDs
		Print-Debug "Generating UUID for filesystem..." 1
		if [[ "${PartFsType}" == "vfat" ]]
		then
			local PartUuid="$(uuidgen | head -c8)"
			local FstabUuid="$(echo "${PartUuid^^}" | sed 's/./&-/4')"
			
		else
			local PartUuid="$(uuidgen | sed "s|[A-Z]|\L&|g")"
			local FstabUuid="${PartUuid}"
		fi
		Print-Debug "Filesystem UUID is ${PartUuid}" 2
		
		
		# Create partitions
		Print-Debug "Creating partition ${PartNum} on ${DiskDevice}..." 1
		sgdisk -n "${PartNum}:${PartStart}:${PartEnd}" "${DiskDevice}"
		sync
		
		
		# Set partition to ESP if specified
		if [[ "${PartType}" == "esp" ]]
		then
			Print-Debug "Setting partition ${DiskDevice}${PartSeparator}${PartNum} type to ESP..." 2
			sgdisk -t "${PartNum}:ef00" "${DiskDevice}"
			sync
		
		fi
		
		# Add label to partition if specified
		if [[ "${PartLabel}" != "null" ]]
		then
			Print-Debug "Setting partition ${DiskDevice}${PartSeparator}${PartNum} name to ${PartLabel}..." 2
			sgdisk -c "${PartNum}:${PartLabel}" "${DiskDevice}"
			sync
			
		fi
		
		# Format partitions
		if [[ "${PartFsType}" == "vfat" ]]
		then
			Print-Debug "Creating fat32 filesystem on ${DiskDevice}${PartSeparator}${PartNum}..." 1
			yes | mkfs.vfat -i "${PartUuid}" -F 32 "${DiskDevice}${PartSeparator}${PartNum}"
			sync
			
		elif [[ "${PartFsType}" == "ext4" ]]
		then
			Print-Debug "Creating ext4 filesystem on ${DiskDevice}${PartSeparator}${PartNum}..." 1
			yes | mkfs.ext4 -U "${PartUuid}" "${DiskDevice}${PartSeparator}${PartNum}"
			sync
			
		elif [[ "${PartFsType}" == "btrfs" ]]
		then
			Print-Debug "Creating btrfs filesystem on ${DiskDevice}${PartSeparator}${PartNum}..." 1
			yes | mkfs.btrfs -f -U "${PartUuid}" "${DiskDevice}${PartSeparator}${PartNum}"
			sync
			
		fi
		
		# Add fstab entry for guest
		echo "UUID=${FstabUuid}	${PartMountPath}	${PartFsType}	${PartMountFlags}	${PartMountBackup}	${PartMountCheck}" >> "${GuestFstab}"
		echo "UUID=${FstabUuid}	${WORKDIR_DISKFS_PATH}${PartMountPath}	${PartFsType}	${PartMountFlags}	${PartMountBackup}	${PartMountCheck}" >> "${MountTab}"
		
	done
}


trap '' EXIT
