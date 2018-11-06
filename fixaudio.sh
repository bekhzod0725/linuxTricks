#!/bin/bash
#
# Author:       Bekhzod Umarov
# Date:         11/05/2018
# Description:  This script will fix audio and video syncing issues caused
#               during screen recording using `recordmydesktop` and `pulse`
#               internal audio monitor when running `recordmydesktop` with
#               the following options:
#               
# Requirements: Need to have `bc`, `avconv` and `sox` installed
#

if [ $# -eq 0 ]; then
    echo "No filename supplied"
elif [ $# -gt 1 ]; then
    echo "Incorrect number of arguments supplied"
else
    FULLNAME=$1
    FILENAME=${FULLNAME%.*}
    EXTENSION=${FULLNAME##*.}

    if [ ! -f $FULLNAME ]; then 
        echo "File: $FULLNAME not found!"
    else
        printf "\n%s\n" "Splitting audio and video channels"
        avconv -i $FULLNAME -c copy -map 0:1 video.$EXTENSION
        avconv -i $FULLNAME -c copy -map 0:2 audio.ogg
        printf "\n%s\n" "Increasing audio pitch/speed"
        sox audio.ogg audioq.ogg speed 1.115
        #sox audio.raw audioq.raw tempo 1.7

        printf "\n%s\n" "Calculating video vs audio length difference"
        DURATION=$(avprobe video.ogv 2>&1| grep 'Duration' | awk '{print $2}' | sed s/,//)
        HOURS=$(echo $DURATION | cut -d ':' -f1)
        MINS=$(echo $DURATION | cut -d ':' -f2)
        SECS=$(echo $DURATION | cut -d ':' -f3)

        video_total=$(echo "$HOURS * 3600 + $MINS*60 + $SECS" | bc)
        printf "%s\n" "Video duration: $video_total"

        DURATION=$(avprobe audioq.ogg 2>&1| grep 'Duration' | awk '{print $2}' | sed s/,//)
        HOURS=$(echo $DURATION | cut -d ':' -f1)
        MINS=$(echo $DURATION | cut -d ':' -f2)
        SECS=$(echo $DURATION | cut -d ':' -f3)

        audio_total=$(echo "$HOURS * 3600 + $MINS*60 + $SECS" | bc)
        printf "%s\n" "Audio duration: $audio_total"

        is_audio=$(echo $audio_total'>'$video_total|bc -l)
        is_video=$(echo $video_total'>'$audio_total|bc -l)

        if (( $is_audio )); then
            printf "%s\n" "Audio is longer"
            res=$(echo "$audio_total/$video_total" | bc -l)
            printf "%s\n" "Difference: $res"
            printf "\n%s\n" "Syncing video with audio length"
            avconv -i video.ogv -filter:v "setpts=$res*PTS" output.mp4
        else
            printf "%s\n" "Video is longer"
            res=$(echo "$audio_total/$video_total" | bc -l)
            printf "%s\n" "Difference: $res"
            printf "\n%s\n" "Syncing video with audio length"
            avconv -i video.ogv -filter:v "setpts=$res*PTS" output.mp4
        fi

        printf "\n%s\n" "Combining video and audio"
        avconv -i output.mp4 -i audioq.ogg -c:a libmp3lame $FILENAME.mp4
        printf "\n%s\n" "Cleanup"
        rm audio.ogg audioq.ogg video.ogv output.mp4
    fi
fi


recordmydesktop --no-frame --no-cursor --s_quality 10 --on-the-fly-encoding
