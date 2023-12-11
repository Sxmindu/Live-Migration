#!/bin/bash

VM="$1"
TAP="$2"
RAM="$3"
CORE="$4"
TYPE="$5"

# Checking and Creating Tap Device
if test -d /sys/class/net/$TAP; then
        echo "Tap Device $TAP Already in Use"
else
        ip tuntap add dev $TAP mode tap
        ip link set dev $TAP master br0
        ip link set dev $TAP up
fi

# Starting the VM in Source Machine
echo "Source VM Started"

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
        -qmp "unix:/media/qmp1,server,nowait" &

# Wait for the VM to boot (adjust sleep time as needed)
sleep 10

# Execute the C program inside the VM using SSH
expect startSysbench.sh

echo ""
echo "Program executes within VM"

# Wait 10 sec
sleep 10

if [ "$TYPE" = "tcp" ]
then
	bash ../../precopy/precopy-vm-migrate.sh
elif [ "$TYPE" = "pp" ]
then
	bash ../../postcopy/postcopy-vm-migrate.sh
elif [ "$TYPE" = "tp" ]
then
<<<<<<< HEAD
	bash ../../hybrid/hybrid-precopy.sh
	sleep 0.5	
=======
	bash ../../hybrid/hybrid-precopy.sh 
        sleep 0.5
>>>>>>> f2992541cdca41732c0bbb3764f7d4af3087a96c
	bash ../../hybrid/hybrid-postcopy.sh
fi

get_migration_details() {
	sleep 20
	bash ../../migration-status.sh
	bash ../../migration-status.sh > output.log
	kill $(pgrep qemu)
}

get_migration_details &
