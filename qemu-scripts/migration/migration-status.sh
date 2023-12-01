#!/bin/bash

# Migrates VM using QMP
cat "$(dirname "$0")/migration-status.txt" | sudo socat - /media/qmp1
