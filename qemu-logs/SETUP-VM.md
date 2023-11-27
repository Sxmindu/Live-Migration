# Compiling Qemu and Setting-up VM

## Compiling Qemu

1. Get the Qemu Version 8.1.2 Modified Source Code from the repository to the Source and Destination Machines

2. Go the qemu-8.1.2 directory and run `./run.sh` script

3. Then Run the Following 

    ```bash
    ./configure 
    make -j8 
    make install -j8
    ```

- You only have to run `./configure` for the first time

## Setting-up the Virtual Machine

1. First create a new virtual hard disk drive for the VM

    ```bash
    qemu-img create -f qcow2 <image_name>.img 15G
    ```

2. Start the VM using Qemu with an OS installer iso file attached as the CD-ROM

    ```bash
    sudo qemu-system-x86_64 \
        -hda <disk_image_name>.img \
        -cdrom <iso_file_name>.iso \
        -boot d \
        -smp 4 \
        -m 8192 \
        -vnc :1 \
        -enable-kvm
    ```

3. Download RealVNC to your laptop and add a new connection. 

4. Use the ip address of the machine that you run the qemu code to open the VM along with the vnc port used (-vnc :1)

    ```bash
        eg: 10.22.196.123:5901
    ```

5. After adding the connection, double tap an open the VM. Then RealVNC will give a GNU of the VM where you can install the OS. 

6. After OS installed success shutdown the VM.

- Always remeber to create the disk image in a folder in the `/var/lib/libvirt/images/` directory as both Source and Destination machine should have access to the image

## Starting VM in the Source Machine

1. First run the following to create the Tap interface for the VM

    ```bash
    ip tuntap add dev <tap_name> mode tap
	ip link set dev <tap_name> master br0
	ip link set dev <tap_name> up
    ```

2. Then run the following command to start the VM in Source Machine using created tap device

    ```bash
    sudo qemu-system-x86_64 \
        -name vm1 \
        -smp 1 \
        -boot c \
        -m 8192 \
        -vnc :1 \
        -drive file=<disk_image_name>.img,if=virtio \
        -net nic,model=virtio,macaddr=52:54:00:12:34:11 \
        -net tap,ifname=<tap_name>,script=no,downscript=no \
        -cpu host --enable-kvm \
        -qmp "unix:/media/qmp1,server,nowait"
    ```

- You can using below scripts to do the above work.

1. `tapDevice.sh` can be use to create or remove a tap device

    ```bash
    ./tapDevice.sh <mode> <tap_name>
    ```
    - use `r` as mode to remove tap device or use `c` to create a tap device

2. `startSource.sh` can be used to start the VM

    ```bash
    ./startSource.sh <disk_image_name> <tap_name>
    ```

    - give the `disk_image_name` without `.img`

## Starting VM in the Destination Machine

1. First run the following to create the Tap interface for the VM

    ```bash
    ip tuntap add dev <tap_name> mode tap
	ip link set dev <tap_name> master br0
	ip link set dev <tap_name> up
    ```

2. Then run the following command to start the VM in Destination Machine using created tap device

    ```bash
    sudo qemu-system-x86_64 \
        -name vm1 \
        -smp 1 \
        -boot c \
        -m 8192 \
        -vnc :1 \
        -drive file=<disk_image_name>.img,if=virtio \
        -net nic,model=virtio,macaddr=52:54:00:12:34:11 \
        -net tap,ifname=<tap_name>,script=no,downscript=no \
        -cpu host --enable-kvm \
        -qmp "unix:/media/qmp1,server,nowait"
        -incoming tcp:0:4444
    ```

- You can using below scripts to do the above work.

1. `tapDevice.sh` can be use to create or remove a tap device

    ```bash
    ./tapDevice.sh <mode> <tap_name>
    ```
    - use `r` as mode to remove tap device or use `c` to create a tap device

2. `startDestination.sh` can be used to start the VM

    ```bash
    ./startDestination.sh <disk_image_name> <tap_name>
    ```

    - give the `disk_image_name` without `.img`

