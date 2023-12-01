#!/bin/bash

NAME=$1

cat ../migration/migration-status.txt | sudo socat - /media/qmp1 > outputs/output.log
scp "base@10.22.196.200:/home/base/Desktop/cpu_usage.log" outputs/cpu_usage.log
python3 log2csv.py outputs/$NAME.csv
