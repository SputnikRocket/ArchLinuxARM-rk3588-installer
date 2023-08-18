#!/bin/bash

echo "Mounting ${1}1 to workdir/boot/"
mount "${1}1" workdir/boot
echo "Mounting ${1}2 to workdir/root/"
mount "${1}2" workdir/root

