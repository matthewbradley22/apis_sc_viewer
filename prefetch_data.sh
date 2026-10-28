#!/usr/bin/env bash

for i in `seq 871 918`
    do
        prefetch "SRR15990${i}" --max-size 60g \
	--resume yes \
	--progress \
 	-O /Volumes/T7/apis_sc_viewer
    done
