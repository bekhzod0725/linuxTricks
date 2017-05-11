#!/bin/bash
#
# Author:       Bekhzod Umarov
# Date:         05/08/2017
# Description:  This script will print out sorted list of folders/files
#               and their human readable sizes. Helpful when trying to 
#               compare differences in dupfolders if you are not sure 
#               what do you want to keep from either folders.
# Requirements: Need to have `bc` installed.
#

DIRECTORY=$1
for dir in `ls $DIRECTORY`; do sudo du $dir | tail -n 1 >> /tmp/values ; done
cat /tmp/values|sort -n | while read line; do 
    X=$(echo $line | cut -d '.' -f 1 ) ;
    
    # Change the line below with the following:
    # echo $line ; 
    # If you wish to keep non-human readable output. Or divide `$X` with 1024
    # as many times as you want if you would like to get the size in GBs or TBs.
    echo $line | sed "s/$X/$(echo $X/1024 | bc -s )M\t/" | grep -v "^0M"; 
done
