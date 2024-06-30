#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#run platform bootloader hook

#bootloader setup
bootloader-platform-hook
