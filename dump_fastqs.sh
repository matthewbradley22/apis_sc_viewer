#!/usr/bin/env bash

#Write file with all current prefetched srr dirs
find /Volumes/T7/apis_sc_viewer -maxdepth 1 -name 'SRR*' > current_srr_files.txt

#Loop through directories
#checking there is only one file within each dir
while read srr_dir; do

    #Get number of files in dir, xargs trims whitespace in return value
    num_files=$(ls -1 "$srr_dir" | wc -l | xargs)

    #If one file in dir, continue
    if [[ "$num_files" == 1 ]]; then 
       fasterq-dump /Volumes/T7/apis_sc_viewer/SRR106933${i} \
        -O /Volumes/T7/apis_sc_viewer \
        -t /Volumes/T7/apis_sc_viewer/tmp/scratch \
        --include-technical
    fi

done < current_srr_files.txt
