from subprocess import run

platforms = [
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
"mixtile-blade3"
]

profiles = [
"minimal",
"xfce"
]

run(["/usr/bin/bash","./run.sh", "/dev/loop0", "none", "minimal", "img", "cache"])
run(["/usr/bin/bash","./run.sh", "/dev/loop1", "none", "xfce", "img", "cache"])

for plat in platforms:
	for prof in profiles:
		run(["/usr/bin/bash","./run.sh", "/dev/loop2", plat, prof, "img", "cache", "shallow"])
