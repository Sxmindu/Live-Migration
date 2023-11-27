#!/bin/bash

#Initial 
cat postcopy-initial.txt | sudo socat - /media/qmp1

# Migrates VM using QMP
cat postcopy-vm-migrate.txt | sudo socat - /media/qmp1
