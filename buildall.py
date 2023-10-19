from subprocess import run

platfoms = [
"orangepi-5plus",
"orangepi-5",
"orangepi-5b",
"rock-5a",
"rock-5b",
"indiedroid-nova",
"nanopi-r6c",
"nanopi-r6s",
"nanopc-t6",
"khadas-edge2",
"mixtile-blade3",
"none"
]

profiles = [
"minimal",
"xfce"
]

for plat in platfoms:
	for prof in profiles:
		run(["/usr/bin/bash","./run.sh", "/dev/loop0", plat, prof, "img"])

