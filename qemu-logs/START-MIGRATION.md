# LIVE MIGARTION USING PRECOPY, POSTCOPY or HYBRID METHOD

1. Start VM in Source and Destination Machines

    ```bash
        ./startSource.sh <disk_image_name> <tap_name> # In Source Machine
        ./startDestination.sh <disk_image_name> <tap_name> # In Destination Machine
    ```
    - use the same `disk image` in both source and destination.

- Use RealVNC to see GUI of the VM 
    - Source: `10.22.196.124:5901`
    - Destination:  `10.22.196.123:5901`

## Precopy Migration

1. Run `precopy-vm-migrate.sh` in Source Machine to start precopy migration

## Postcopy Migration

1. First run `postcopy-dst-ram.sh` in Destination Machine

2. Then run `postcopy-vm-migrate.sh` in Source Machine to start postcopy migration

## Hybrid Migration

1. First run `postcopy-dst-ram.sh` in Destination Machine

2. Then run `hybrid-precopy.sh` in Source Machine to start precopy migration

3. While precopy iterations execute run `hybrid-postcopy.sh` in Source Machine to change into postcopy migration

##

- All the above mentioned scripts can be found in `qemu-scripts` folder.