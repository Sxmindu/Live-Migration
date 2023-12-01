#!/bin/bash

#Initial 
cat "$(dirname "$0")/postcopy/postcopy-initial.txt" | sudo socat - /media/qmp1

