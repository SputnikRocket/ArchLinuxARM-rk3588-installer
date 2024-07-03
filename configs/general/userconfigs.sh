#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

#Locale
INSTALL_LOCALE="en_US.UTF-8"
INSTALL_LOCALE_ENC="UTF-8"

#Hostname
INSTALL_HOSTNAME="alarm-uefi"




