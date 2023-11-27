#!/bin/bash


# Migrates VM using QMP
cat precopy-vm-migrate.txt | sudo socat - /media/qmp1
