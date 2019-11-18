#!/bin/bash
#This script does a very simple test for checking disk space.
space=$(df -h | awk '{print $5}' | grep % | grep -v Use | sort -n \
| tail -1 | cut -d "%" -f1 -)
echo "largest occupied space = $space%"
case $space in
[1-6]*)
Message1="All OK."
;;
[7-8]*)
Message1="Cleaning out. There's a partition that is $space % full."
;;
9[0-8]*)
Message1="Better buy a new disk... One partition is $space % full."
;;
99)
Message1="I'm drowning here! There's a partition at $space %!"
;;
*)
Message1="I seem to be running with an nonexistent disk..."
;;

esac
echo $Message1

space=$(df -h | awk '{print $4}' | grep G | grep -v Avail | sort -n \
| tail -1 )
space1=$(df -h | awk '{print $5}' | grep G| grep -v Filesystem | sort -n \
| tail -1 | cut -d "%" -f1 -)
echo "Mais espaço livre numa partição = $space"
echo "Particao com mais espaço = $space1"

