#!/bin/bash

# Migrates VM using QMP
cat migration-status.txt | sudo socat - /media/qmp1
