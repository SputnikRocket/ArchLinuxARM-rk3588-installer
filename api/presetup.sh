#!/bin/bash

set -eE
trap 'Print-Error " in api/yaml.sh on line ${LINENO}"' ERR

# Check if all requrements for installer are satisfied
function Check-Cmds () {
	local YamlFiles=("${@:?}")
	
	Yaml-Element-MergeLists ".checkcmd" "${YamlFiles[@]}"
	local CmdList="${YamlOutput:?}"
	
	Print-Debug "Checking if required tools are available..." 1
	for Cmd in ${CmdList}
	do
		Print-Debug "Checking for existence of ${Cmd} on host..." 2
		
		if [[ -z $(command -v "${Cmd}") ]]
		then
			Print-Error "${Cmd} Missing! please install it before running this again"
		exit 1
	fi
	done
}

# Create working & output directories
function Create-Workdirs () {
	local PathsConf=${1:?}
	
	local DirList
	DirList=($(cat "${PathsConf}" | grep "WORKDIR\|OUTPUT" | grep "PATH" | sed 's|export\ ||g' | sed 's|=.*||g'))
	
	Print-Debug "Creating working & output directories..." 3
	for Dir in "${DirList[@]}"
	do
		Print-Debug "Creating directory ${!Dir}" 4
		mkdir -p "${!Dir}"
	done
}
