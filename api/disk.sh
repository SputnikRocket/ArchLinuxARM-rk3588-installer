#!/bin/bash

set -eE
trap 'Print-Error " in api/disk.sh on line ${LINENO}"' ERR

# Wipe disk & create partitions
function Setup-Disk () {
	local DiskDevice=${1}
	local ConfigYaml=${2}

	
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
	Print-Debug "Recreating GPT on ${DiskDevice}..." 1
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
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.partinfo.typecode"
		local PartTypeCode="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.partinfo.filesystem"
		local PartFsType="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.partinfo.offsets.start"
		local PartStart="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.partinfo.offsets.end"
		local PartEnd="${YamlOutput}"
		
		
		# Get mount details
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.mountopts.path"
		local PartMountPath="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.mountopts.flags"
		local PartMountFlags="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.mountopts.backup"
		local PartMountBackup="${YamlOutput}"
		
		Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.mountopts.check"
		local PartMountCheck="${YamlOutput}"
		
				
		# Generate filesystem UUID
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
		
		
		# Create partition
		Print-Debug "Creating partition ${PartNum} on ${DiskDevice}..." 1
		sgdisk -n "${PartNum}:${PartStart}:${PartEnd}" "${DiskDevice}"
		sync
		
		
		# Set partition type if specified
		if [[ "${PartTypeCode}" != "null" ]]
		then
			Print-Debug "Setting partition ${DiskDevice}${PartSeparator}${PartNum} type code to ${PartTypeCode}..." 2
			sgdisk -t "${PartNum}:${PartTypeCode}" "${DiskDevice}"
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
			
		elif [[ "${PartFsType}" == "f2fs" ]]
		then
			Print-Debug "Creating f2fs filesystem on ${DiskDevice}${PartSeparator}${PartNum}..." 1
			yes | mkfs.f2fs -f -U "${PartUuid}" "${DiskDevice}${PartSeparator}${PartNum}"
			sync
		
		elif [[ "${PartFsType}" == "btrfs" ]]
		then
			Print-Debug "Creating btrfs filesystem on ${DiskDevice}${PartSeparator}${PartNum}..." 1
			yes | mkfs.btrfs -f -U "${PartUuid}" "${DiskDevice}${PartSeparator}${PartNum}"
			sync
			
			
			# Check if the BTRFS filesystem has subvolumes
			Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.hassubvols"
			local HasSubVols="${YamlOutput}"
			
			
			# Create subvolumes if above is yes 
			if [[ "${HasSubVols}" == "yes" ]]
			then
				# Get list of subvolumes
				Yaml-Element-GetSubLists "${ConfigYaml}" ".partitions.${Part}.subvols"
				local SubVols="${YamlOutput}"
				
				
				# Mount BTRFS parent volume
				mount "${DiskDevice}${PartSeparator}${PartNum}" "${WORKDIR_DISKFS_PATH}"
				
				
				# Recurse through subvolume list, creating each one
				for SubVol in ${SubVols}
				do
					# Get subvolume details
					Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.subvols.${SubVol}.name"
					local SubVolName="${YamlOutput}"
					
					Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.subvols.${SubVol}.mountopts.path"
					local SubVolMountPath="${YamlOutput}"
		
					Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.subvols.${SubVol}.mountopts.flags"
					local SubVolMountFlags="${YamlOutput}"
		
					Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.subvols.${SubVol}.mountopts.backup"
					local SubVolMountBackup="${YamlOutput}"
		
					Yaml-Element-GetVal "${ConfigYaml}" ".partitions.${Part}.subvols.${SubVol}.mountopts.check"
					local SubVolMountCheck="${YamlOutput}"
					
					
					# Create subvolume
					btrfs subvolume create "${WORKDIR_DISKFS_PATH}/${SubVolName}"
					
					
					# Check if subvolume doesn't have a mountpoint
					if [[ "${SubVolMountPath}" != "null" ]]
					then
						# Create fstab entry and mount path
						Print-Debug "Adding entry for ${SubVolMountPath} to base fstab..." 3
						echo "UUID=${FstabUuid}	${SubVolMountPath}	${PartFsType}	${SubVolMountFlags},subvol=/${SubVolName}	${SubVolMountBackup}	${SubVolMountCheck}" >> "${WORKDIR_TRANSIENT_PATH}/fstab_initial"
						echo "${SubVolMountPath}" >> "${WORKDIR_TRANSIENT_PATH}/mounts_initial"
			
					fi
					
				done
				
				
				# Unmount BTRFS parent volume
				umount "${DiskDevice}${PartSeparator}${PartNum}"
				
			fi
				
		fi
		
		# Check if partition doesn't have a mount point or is BTRFS with subvolumes
		if [[ "${PartMountPath}" != "null" ]] || [[ "${HasSubVols}" != "yes" ]]
		then
			# Create fstab entry and mount path
			Print-Debug "Adding entry for ${PartMountPath} to base fstab..." 3
			echo "UUID=${FstabUuid}	${PartMountPath}	${PartFsType}	${PartMountFlags}	${PartMountBackup}	${PartMountCheck}" >> "${WORKDIR_TRANSIENT_PATH}/fstab_initial"
			echo "${PartMountPath}" >> "${WORKDIR_TRANSIENT_PATH}/mounts_initial"
			
		fi
		
	done
	
	# Rebuild mounts and fstabs in proper order
	Print-Debug "Generating final fstabs..." 1
	Print-Debug "Generating fstab for guest..." 2
	sort -n "${WORKDIR_TRANSIENT_PATH}/mounts_initial" > "${WORKDIR_TRANSIENT_PATH}/mounts_final"
	while read -r Mount
	do
		grep "$(printf '\t')${Mount}$(printf '\t')" "${WORKDIR_TRANSIENT_PATH}/fstab_initial" >> "${WORKDIR_TRANSIENT_PATH}/fstab_final.guest"
		
	done < "${WORKDIR_TRANSIENT_PATH}/mounts_final"
	
	# Create installer fstab
	Print-Debug "Generating fstab for installer..." 2
	sed -E "s|\t\/|\t${WORKDIR_DISKFS_PATH}\/|g" "${WORKDIR_TRANSIENT_PATH}/fstab_final.guest" > "${WORKDIR_TRANSIENT_PATH}/fstab_final.installer"

}

trap '' EXIT
