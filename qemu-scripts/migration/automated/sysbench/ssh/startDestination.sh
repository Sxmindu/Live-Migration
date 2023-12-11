#!/usr/bin/expect -f

set VM [lindex $argv 0];
set TAP [lindex $argv 1];
set RAM [lindex $argv 2];
set CORE [lindex $argv 3];
set POST [lindex $argv 4];

spawn ssh root@10.22.196.123
expect "password"
send "primedirective\r"
expect "$"
send "cd /var/lib/libvirt/images/Live-Migration/scripts/migration/automated/sysbench\r"
expect "$"
send "bash sysbenchDestination.sh $VM $TAP $RAM $CORE $POST\r"
expect "$"
exit 100
expect eof
