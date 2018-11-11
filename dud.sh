#!/bin/bash
#
# Author:       Bekhzod Umarov
# Date:         05/08/2017 (edited 11/10/2018)
# Description:  This script will print out sorted list of folders/files
#               and their human readable sizes. Helpful when trying to 
#               compare differences in dupfolders if you are not sure 
#               what do you want to keep from either folders.
#

DIRECTORY=$1
(ls "$DIRECTORY" | while read dir; do
    fpath=$(readlink -f "$DIRECTORY/$dir");
    duinfo=$(du "$fpath" | tail -n 1 | awk '{print $1/1024 "M"}');
    fpath=$(basename "$fpath");
    echo $duinfo \| "$fpath";
done) | column -t -s \| 
