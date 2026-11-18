#!/usr/bin/env bash

#From lino 2023 paper
for i in `seq 71 82`
    do
        prefetch "DRX3868${i}" --max-size 60g \
        --resume yes \
        --progress \
        -O /Volumes/T7/apis_sc_viewer
    done

#From Traniello 2023 aggression paper
for i in `seq 56 63`
    do
        prefetch "SRR106933${i}" --max-size 60g \
        --resume yes \
        --progress \
        -O /Volumes/T7/apis_sc_viewer
    done

#From the Zhang 2022 vitellogenin paper
for i in `seq 871 918`
    do
        prefetch "SRR15990${i}" --max-size 60g \
	--resume yes \
	--progress \
 	-O /Volumes/T7/apis_sc_viewer
    done
