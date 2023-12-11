#!/bin/bash

VM="$1"
TAP="$2"
RAM="$3"
CORE="$4"
TYPE="$5"
POST=""

DESTINATION_READY=""
START_SYSBENCH=""
VM_STOPPED=""
MIGRATION=""

terminate-qemu (){
	kill $(pgrep qemu)

	expect ssh/stopVM.sh 
	VM_STOP=$?
	printf "\n\n"
}

get_migration_details() {
	sleep 20

	MIGRATION=$(bash ../../migration-status.sh)
	
	terminate-qemu
	
	log "Disk: $VM"	
	log "Destination-Ready: $DESTINATION_READY"
	log "start-sysbench: $START_SYSBENCH"
       	log "vm_stop: $VM_STOP"
       	log "migration:"
	log "$MIGRATION" 
	log ""

}

log() {
	echo $1 >> experiment_${RAM}_${CORE}.txt
}

printf ">>> Readying Destination to Recieve VM\n"
if [ "$TYPE" = "tcp" ]
then
	POST="false"
else
	POST="true"
fi

# Making Destination Ready to Recieve
expect ssh/startDestination.sh $VM $TAP $RAM $CORE $POST
DESTINATION_READY=$?
printf "\n"

if [[ $DESTINATION_READY -eq 100 ]] 
then	
	printf ">>> Destination Ready\n"
else
	exit -1
fi

# Checking and Creating Tap Device
if test -d /sys/class/net/$TAP; then
        printf "Tap Device %s Already in Use\n" $TAP
else
        ip tuntap add dev $TAP mode tap
        ip link set dev $TAP master br0
        ip link set dev $TAP up
fi

# Starting the VM in Source Machine
printf ">>> Starting VM in Source\n"

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

printf ">>> VM Up & Running\n"

# Wait for the VM to boot (adjust sleep time as needed)
sleep 15

# Execute the C program inside the VM using SSH
expect ssh/startSysbench.sh
START_SYSBENCH=$?
printf "\n"
if [[ $START_SYSBENCH -eq 100 ]] 
then	
	printf ">>> Sysbench Executing in VM\n"
else
	terminate-qemu
	exit -1
fi

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
	bash ../../hybrid/hybrid-precopy.sh
	sleep 0.5	
	bash ../../hybrid/hybrid-postcopy.sh
fi

get_migration_details &
