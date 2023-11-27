# HOST CONFIGURATIONS

## IPs

- Source : `10.22.196.124`
- Destination : `10.22.196.123`
- Gateway : `10.22.196.254`
- DNS : `10.22.254.10`

## Configuring Netork in Host Machines

- Run below code to setup a bridge, assign ip to the bridge and add gateway 

    ```bash
    ip link add dev br0 type bridge
    ip link set dev br0 up
    ip link set dev enp1s0 up
    ip link set dev enp1s0 master br0
    ip addr add <host_ip>/24 dev br0
    ip route add default via 10.22.196.254 dev br0
    ```
    - This is already setuped in both host machines, if the bridge in the machine is removed accidently use the above code to set it up again.

## Network File System

- A distributed file system is required to facilitate Live migration, therefor by using a Network File System `/var/lib/libvirt/images/` directory is shared by Source and Destination Machine.

- Run `startNFS` keyword after starting the Source Machine.