#!/bin/bash

NAME="$1"

qemu-img create -f qcow2 ../vm-images/$NAME.img 15G

echo 'Starting VM'

sudo qemu-system-x86_64 \
	-hda ../vm-images/$NAME.img \
	-cdrom /var/lib/libvirt/images/ubuntu-desktop-14.04.6.iso \
	-boot d \
	-smp 4 \
	-m 8192 \
	-vnc :1 \
	-enable-kvm

echo 'VM Stopped'
