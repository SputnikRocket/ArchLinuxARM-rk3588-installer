#!/bin/bash

set -eE
trap 'Print-Error " in api/yaml.sh on line ${LINENO}"' ERR

# Return first level list elements
function Yaml-Element-GetSubLists () {
	
	local YamlFile=${1}
	local Address=${2}
	
	local Elements
	export YamlOutput
	
	Print-Debug "Getting Elements from ${YamlFile} at ${Address}" 3
	Elements=$(yq -y "${Address}" < "${YamlFile}" | sed "/\ \ .*/d" | sed "s|:||g")
	
	Print-Debug "Retreived Elements:\n${Elements}" 4
	YamlOutput="${Elements}"
}

# Return value from element
function Yaml-Element-GetVal () {
	
	local YamlFile=${1}
	local Address=${2}
	
	local Element
	export YamlOutput

	Print-Debug "Getting Element from ${YamlFile} at ${Address}" 3
	Element=$(yq -y "${Address}" < "${YamlFile}" | sed "/\.\.\./d" | sed "s|'||g")
	
	Print-Debug "Retreived Element: ${Element}" 4
	YamlOutput="${Element}"
}

# Return values from list
function Yaml-Element-GetList () {
	
	local YamlFile=${1}
	local Address=${2}
	
	local Elements
	export YamlOutput
	
	Print-Debug "Getting Elements from ${YamlFile} at ${Address}" 3
	Elements=$(yq -y "${Address}" < "${YamlFile}" | sed "s|-\ ||g")
	
	Print-Debug "Retreived Elements:\n${Elements}" 4
	YamlOutput="${Elements}"
}

# Merge lists and eliminate duplicates
function Yaml-Element-MergeLists () {
	
	local Address=${1}
	local YamlFiles=($(echo "${@}" | sed "s|${1}\ ||g"))
	
	local Elements
	local MergedElements
	export YamlOutput
	
	for YamlFile in "${YamlFiles[@]}"
	do
		Print-Debug "Getting Elements from ${YamlFile} at ${Address}" 3
		Elements=$(yq -y "${Address}" < "${YamlFile}" | sed "s|-\ ||g")
		
		Print-Debug "Retreived Elements:\n${Elements}" 4
	    MergedElements="${MergedElements}\n${Elements}"
	done
	
	MergedElements=$(echo "${MergedElements}" | sort -u | sed "/^$/d")
	
	Print-Debug "Merged Elements:\n${MergedElements}" 4
	YamlOutput="${MergedElements}"
}

trap '' EXIT
