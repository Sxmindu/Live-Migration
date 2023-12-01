#!/bin/bash

# Migrates VM using QMP in Post-copy mode
cat "$(dirname "$0")/hybrid-postcopy.txt" | sudo socat - /media/qmp1
