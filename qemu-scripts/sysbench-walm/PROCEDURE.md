# PROCEDURE

1. Insatll moreutils package in the VM `sudo apt-get install moreutils`

2. First ready the destination by running `./sysbenchDestination <wm-image-name> <tap-device-name> <true: If postcopy or hybrid | false: If precopy>`

    ```bash
        ./sysbenchDestination disk1 tap0 true
    ```

3. Then run `./sysbenchSource <wm-image-name> <tap-device-name> <ram-size> <migration-type>` in source

    ```bash
        Migration Types
        tcp : Precopy
        pp : postcopy
        tp : hybrid
    ```

4. After migration is completed run `./aftermigration.sh <name-for-the-csv>`, Remember to create a directory name outputs before running thi script.

5. If data about the migartion is not in `outputs/output.log` run `cat ../migration/migration-status.txt | sudo socat - /media/qmp1 > outputs/output.log`