#!/usr/bin/expect -f

spawn ssh root@10.22.196.123
expect "password"
send "primedirective\r"
expect "$"
send "kill \$(pgrep qemu)\r"
expect "$"
exit 100
expect eof
