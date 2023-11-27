#!/bin/bash

#Initial 
cat hybrid-initial.txt | sudo socat - /media/qmp1

# Migrates VM using QMP
cat hybrid-precopy.txt | sudo socat - /media/qmp1
