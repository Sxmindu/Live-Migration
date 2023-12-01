#!/bin/bash

VM="$1"
TAP="$2"
RAM="$3"
CORE="$4"
POST="$5"

if test -d /sys/class/net/$TAP; then
	echo "Tap Device $TAP Already in Use"
else
	ip tuntap add dev $TAP mode tap
	ip link set dev $TAP master br0
	ip link set dev $TAP up
fi

sudo qemu-system-x86_64 \
	-name base \
	-smp $CORE \
	-boot c \
	-m $RAM \
	-vnc :1 \
	-drive file=/var/lib/libvirt/images/Live-Migration/vm-images/$VM.img,if=virtio \
	-net nic,model=virtio,macaddr=52:54:00:12:34:11 \
	-net tap,ifname=$TAP,script=no,downscript=no \
	-cpu host --enable-kvm \
	-qmp "unix:/media/qmp1,server,nowait" \
	-incoming tcp:0:4444 &

sleep 2

if [ "$POST" = "true" ]
then
	bash ../../postcopy-dst-ram.sh
fi

echo "Destination Ready to Recieve VM"
