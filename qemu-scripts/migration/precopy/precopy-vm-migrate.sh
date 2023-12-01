#!/bin/bash

# Migrates VM using QMP
cat "$(dirname "$0")/precopy-vm-migrate.txt" | sudo socat - /media/qmp1
