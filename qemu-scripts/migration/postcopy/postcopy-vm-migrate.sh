#!/bin/bash

#Initial 
cat "$(dirname "$0")/postcopy-initial.txt" | sudo socat - /media/qmp1

# Migrates VM using QMP
cat "$(dirname "$0")/postcopy-vm-migrate.txt" | sudo socat - /media/qmp1
