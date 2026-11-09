#!/usr/bin/env bash

for i in $(seq 55 63);
do
    fasterq-dump /Volumes/T7/apis_sc_viewer/SRR106933${i} \
    -O /Volumes/T7/apis_sc_viewer \
    -t /Volumes/T7/apis_sc_viewer/tmp/scratch \
    --include-technical
done


