#!/bin/bash
#This script opens 4 terminal windows.

i="0"
while [[ $i -lt 4 ]]; do
xterm &
i=$(($i+1))
done

i="0"
until [[ $i -eq 4 ]]; do
xterm &
echo "ola"
i=$(($i+1))
done;