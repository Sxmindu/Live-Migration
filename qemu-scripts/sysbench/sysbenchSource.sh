#!/bin/bash

VM="$1"
TAP="$2"
RAM="$3"
TYPE="$4"

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
        -smp 1 \
        -boot c \
        -m $RAM \
        -vnc :1 \
        -drive file=../../vm-images/$VM.img,if=virtio \
        -net nic,model=virtio,macaddr=52:54:00:12:34:11 \
        -net tap,ifname=$TAP,script=no,downscript=no \
        -cpu host --enable-kvm \
        -qmp "unix:/media/qmp1,server,nowait" &

# Wait for the VM to boot (adjust sleep time as needed)
sleep 2

# Execute the C program inside the VM using SSH
ssh base@10.22.196.200 << 'EOF'
cd Desktop
bash executeSysbench.sh &
EOF

echo "Program executes within VM"

# Wait 10 sec
sleep 10

# Take the CPU Usage %
ssh base@10.22.196.200 << 'EOF'
pid=$(pgrep sysbench)
echo "This is the pid"
echo $pid
top -b -d 1 -n 60 -p "$pid" | grep --line-buffered 'sysbench' > /home/base/Desktop/cpu_usage.log
EOF

sudo scp "base@10.22.196.200:/home/base/Desktop/cpu_usage.log" cpu_usage.log

if [ "$TYPE" = "tcp"]
then
	cat ../migration/precopy/precopy-vm-migrate.txt | sudo socat - /media/qmp1
elif [ "$TYPE" = "pp" ]
then
	cat ../migration/postcopy/postcopy-initial.txt | sudo socat - /media/qmp1
        cat ../migration/postcopy/postcopy-vm-migrate.txt | sudo socat - /media/qmp1
elif [ "$TYPE" = "tp" ]
then
        cat ../migration/hybrid/hybrid-initial.txt | sudo socat - /media/qmp1
        cat ../migration/hybrid/hybrid-precopy.txt | sudo socat - /media/qmp1
	sleep 5
        cat ../migration/hybrid/hybrid-postcopy.txt | sudo socat - /media/qmp1
fi

cat ../migration/migration-status.txt | sudo socat - /media/qmp1
cat ../migration/migration-status.txt | sudo socat - /media/qmp1
cat ../migration/migration-status.txt | sudo socat - /media/qmp1 >> output.log

#killall qemu-system-x86_64
# Optionally, you can also shut down the VM after execution
# $QEMU -monitor stdio -display none -xlate to=none -device isa-debug-exit,iobase=0xf4,iosize=0x04