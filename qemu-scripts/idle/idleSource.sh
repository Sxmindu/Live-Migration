#!/bin/bash

VM="$1"
TAP="$2"
TYPE="$3"

if test -d /sys/class/net/$TAP; then
	echo "Tap Device $TAP Already in Use"
else
	ip tuntap add dev $TAP mode tap
	ip link set dev $TAP master br0
	ip link set dev $TAP up
fi

sudo qemu-system-x86_64 \
	-name vm1 \
	-smp 1 \
	-boot c \
	-m 8192 \
	-vnc :1 \
	-drive file=../../vm-images/$VM.img,if=virtio \
	-net nic,model=virtio,macaddr=52:54:00:12:34:11 \
	-net tap,ifname=$TAP,script=no,downscript=no \
	-cpu host --enable-kvm \
	-qmp "unix:/media/qmp1,server,nowait" &

sleep 60

if ($TYPE = "Pre"); then
	bash ../migration/precopy/precopy-vm-migrate.sh
else if ($TYPE = "Post"); then
	bash ../migration/postcopy/postcopy-vm-migrate.sh
else if ($TYPE = "Hybrid"); then
	bash ../migration/hybrid/hybrid-precopy.sh
	sleep 5
	bash ../migration/hybrid/hybrid-postcopy.sh
fi

bash migration-status.sh
bash migration-status.sh
bash migration-status.sh > output.log
