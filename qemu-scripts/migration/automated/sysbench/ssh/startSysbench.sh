#!/usr/bin/expect -f

spawn ssh base@10.22.196.200
expect "password"
send "base\r"
expect "$"
send "cd Desktop\r"
expect "$"
send "bash executeSysbench.sh\r"
expect "$"
exit 100
expect eof
