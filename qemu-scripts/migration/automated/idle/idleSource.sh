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
	-name base \
	-smp 1 \
	-boot c \
	-m 8192 \
	-vnc :1 \
	-drive file=/var/lib/libvirt/images/Live-Migration/vm-images/$VM.img,if=virtio \
	-net nic,model=virtio,macaddr=52:54:00:12:34:11 \
	-net tap,ifname=$TAP,script=no,downscript=no \
	-cpu host --enable-kvm \
	-qmp "unix:/media/qmp1,server,nowait" &

sleep 10

if [ "$TYPE" = "tcp" ]
then
	bash ../../precopy/precopy-vm-migrate.sh
elif [ "$TYPE" = "pp" ]
then
	bash ../../postcopy/postcopy-vm-migrate.sh
elif [ "$TYPE" = "tp" ]
then
	bash ../../hybrid/hybrid-precopy.sh 
	sleep 0.5
	bash ../../hybrid/hybrid-postcopy.sh
fi

get_migration_details() {
	sleep 20
	bash ../../migration-status.sh
	bash ../../migration-status.sh > output.log
}

get_migration_details &

