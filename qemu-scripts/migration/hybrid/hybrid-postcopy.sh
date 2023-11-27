#!/bin/bash

# Migrates VM using QMP in Post-copy mode
cat hybrid-postcopy.txt | sudo socat - /media/qmp1
