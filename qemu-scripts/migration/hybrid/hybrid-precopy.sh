#!/bin/bash

#Initial 
cat "$(dirname "$0")/hybrid-initial.txt" | sudo socat - /media/qmp1

# Migrates VM using QMP
cat "$(dirname "$0")/hybrid-precopy.txt" | sudo socat - /media/qmp1
