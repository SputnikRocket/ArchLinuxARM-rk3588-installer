#!/bin/bash

set -eE
trap 'Print-Error " in api/yaml.sh on line ${LINENO}"' ERR

# Return first level list elements
function Yaml-Element-GetSubLists () {
	
	local YamlFile=${1}
	local Address=${2}
	
	Print-Debug "Getting Elements from ${YamlFile} at ${Address}" 3
	local Elements=$(yq -y "${Address}" < "${YamlFile}" | sed "/\ \ .*/d" | sed "s|:||g")
	
	Print-Debug "Retreived Elements:\n${Elements}" 4
	YamlOutput="${Elements}"
}

# Return value from element
function Yaml-Element-GetVal () {
	
	local YamlFile=${1}
	local Address=${2}

	Print-Debug "Getting Element from ${YamlFile} at ${Address}" 3
	local Element=$(yq -y "${Address}" < "${YamlFile}" | sed "/\.\.\./d" | sed "s|'||g")
	
	Print-Debug "Retreived Element: ${Element}" 4
	YamlOutput="${Element}"
}

# Return values from list
function Yaml-Element-GetList () {
	
	local YamlFile=${1}
	local Address=${2}
	
	Print-Debug "Getting Elements from ${YamlFile} at ${Address}" 3
	local Elements=$(yq -y "${Address}" < "${YamlFile}" | sed "s|-\ ||g")
	
	Print-Debug "Retreived Elements:\n${Elements}" 4
	YamlOutput="${Elements}"
}

trap '' EXIT
