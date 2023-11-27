#!/bin/bash
# make sure to specify the command line argument as the message to send
echo $1 > /dev/udp/10.128.0.46/3333

